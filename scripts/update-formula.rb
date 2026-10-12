#!/usr/bin/env ruby
# typed: strict
# frozen_string_literal: true

require "json"
require "fileutils"
require "open3"
require "tmpdir"

app = ARGV.fetch(0) { abort("usage: update-formula.rb <app> [tag]") }
release_tag = ARGV[1].to_s
repo = "3leaps/#{app}"
out_file = "Formula/#{app}.rb"

description_for = lambda do |name|
  {
    "decernor" => "Local key-material hygiene and readiness checks",
    "kitfly"   => "Turn your writing into a website",
    "gonimbus" => "Cloud object storage crawl, inspect, and streaming CLI",
    "mdmeld"   => "Pack directory trees into markdown archives for AI sharing",
    "seclusor" => "Git-trackable secrets management with age encryption",
    "sfetch"   => "Secure and verifiable release-asset downloader",
    "spanwit"  => "Context-aware disk-space diagnostics and safe reclamation",
  }.fetch(name, "#{name} command-line tool")
end

test_args_for = lambda do |name|
  {
    "decernor" => ["version"],
    "kitfly"   => ["--version"],
    "gonimbus" => ["version"],
    "mdmeld"   => ["--help"],
    "spanwit"  => ["version"],
  }.fetch(name, ["--version"])
end

caveats_for = lambda do |name|
  {
    "spanwit" => "spanwit prune is a dry run unless you pass --execute; only then does it delete anything.\n" \
                 "Usage and safety model: https://github.com/3leaps/spanwit#readme",
  }[name]
end

license_for = lambda do |name|
  {
    "gonimbus" => "Apache-2.0",
    "sfetch"   => "Apache-2.0",
  }.fetch(name, "MIT")
end

release_command = ["gh", "release", "view"]
release_command << release_tag unless release_tag.empty?
release_command += ["--repo", repo, "--json", "tagName,assets,name,isDraft,isPrerelease"]
release_json, release_error, release_status = Open3.capture3(*release_command)
unless release_status.success?
  abort(release_error.empty? ? "error: failed to read release for #{repo}" : release_error)
end

release = JSON.parse(release_json)
if release["isDraft"] || release["isPrerelease"]
  abort("error: requested release for #{repo} is not a published stable release")
end

tag_name = release.fetch("tagName")
version = tag_name.delete_prefix("v")
class_name = app.split(/[^a-zA-Z0-9]/).map(&:capitalize).join
archive_profile = case app
when "decernor", "spanwit" then :versioned
when "sfetch" then :unversioned
end

assets = release.fetch("assets")
required = {
  "darwin_arm64" => "#{app}-darwin-arm64",
  "linux_amd64"  => "#{app}-linux-amd64",
  "linux_arm64"  => "#{app}-linux-arm64",
}
optional = { "darwin_amd64" => "#{app}-darwin-amd64" }
if archive_profile == :versioned
  required = {
    "darwin_arm64" => "#{app}_#{version}_darwin_arm64.tar.gz",
    "linux_amd64"  => "#{app}_#{version}_linux_amd64.tar.gz",
    "linux_arm64"  => "#{app}_#{version}_linux_arm64.tar.gz",
  }
  optional = { "darwin_amd64" => "#{app}_#{version}_darwin_amd64.tar.gz" }
elsif archive_profile == :unversioned
  required = {
    "darwin_arm64" => "#{app}_darwin_arm64.tar.gz",
    "linux_amd64"  => "#{app}_linux_amd64.tar.gz",
    "linux_arm64"  => "#{app}_linux_arm64.tar.gz",
  }
  optional = {}
end

# Hashes come only from a SHA256SUMS whose minisign signature verifies against
# the key pinned for this app in keys/minisign-pubkeys.txt. GitHub's asset
# digest is a cross-check; any disagreement refuses the update.
keys_file = ENV.fetch("TAP_MINISIGN_KEYS_FILE", File.expand_path("../keys/minisign-pubkeys.txt", __dir__))
pinned_keys = File.readlines(keys_file).map(&:split)
pinned_keys = pinned_keys.select { |fields| fields.length == 2 && fields[0] == app }.map(&:last)
abort("error: no pinned minisign key for #{app} in #{keys_file}") if pinned_keys.length != 1
pinned_key = pinned_keys.first

%w[SHA256SUMS SHA256SUMS.minisig].each do |name|
  abort("error: release #{tag_name} for #{repo} has no #{name}") unless assets.any? { |item| item["name"] == name }
end

signed_sums = Dir.mktmpdir("homebrew-tap-sums") do |dir|
  _out, download_error, download_status = Open3.capture3(
    "gh", "release", "download", tag_name, "--repo", repo,
    "--pattern", "SHA256SUMS", "--pattern", "SHA256SUMS.minisig", "--dir", dir
  )
  unless download_status.success?
    abort(download_error.empty? ? "error: failed to download SHA256SUMS for #{repo}" : download_error)
  end

  sums_path = File.join(dir, "SHA256SUMS")
  verify_out, _verify_error, verify_status = Open3.capture3(
    "minisign", "-V", "-P", pinned_key, "-m", sums_path, "-x", "#{sums_path}.minisig"
  )
  unless verify_status.success?
    abort("error: SHA256SUMS signature for #{repo} #{tag_name} does not verify against the pinned key")
  end

  # A trusted comment that names this app must name this tag, so an older
  # signed manifest cannot be replayed under a newer release. A comment that does
  # not start with "<app> v" (minisign's default timestamp form) is not checked.
  comment = verify_out[/^Trusted comment: (.*)$/, 1].to_s
  comment_tag = comment[/\A#{Regexp.escape(app)} (v\S+)/, 1]
  if comment_tag && comment_tag != tag_name
    abort("error: SHA256SUMS for #{repo} is signed for #{comment_tag}, not #{tag_name}")
  end

  File.readlines(sums_path).each_with_object({}) do |line, sums|
    digest, name = line.split
    next if digest.nil? || name.nil?

    abort("error: malformed SHA256SUMS line for #{repo}") unless digest.match?(/\A[0-9a-f]{64}\z/)
    name = name.delete_prefix("*")
    abort("error: #{name} is listed twice in the SHA256SUMS for #{repo}") if sums.key?(name)

    sums[name] = digest
  end
end

resolve_asset = lambda do |asset_name, asset|
  digest = signed_sums[asset_name]
  abort("error: #{asset_name} is not listed in the signed SHA256SUMS for #{repo}") unless digest

  github_digest = asset["digest"].to_s.delete_prefix("sha256:")
  if !github_digest.empty? && github_digest != digest
    abort("error: GitHub digest for #{asset_name} differs from the signed SHA256SUMS for #{repo}")
  end

  { "url" => asset.fetch("url"), "sha256" => digest, "name" => asset_name }
end

resolved = required.transform_values do |asset_name|
  asset = assets.find { |item| item["name"] == asset_name }
  abort("error: missing release asset #{asset_name} for #{repo}") unless asset

  resolve_asset.call(asset_name, asset)
end

optional.each do |key, asset_name|
  asset = assets.find { |item| item["name"] == asset_name }
  next unless asset

  resolved[key] = resolve_asset.call(asset_name, asset)
end

lines = []
lines << "class #{class_name} < Formula"
lines << "  desc #{description_for.call(app).inspect}"
lines << "  homepage \"https://github.com/#{repo}\""
lines << "  license #{license_for.call(app).inspect}"
unless resolved["darwin_amd64"]
  lines << ""
  lines << "  # No darwin-amd64 binary is published. The head spec gives unsupported"
  lines << "  # platforms a buildable fallback and keeps tap-wide readall checks valid."
  lines << "  head \"https://github.com/#{repo}.git\", branch: \"main\""
end
lines << ""
lines << "  on_macos do"
unless resolved["darwin_amd64"]
  lines << "    depends_on arch: :arm64"
  lines << ""
end
if resolved["darwin_amd64"]
  lines << "    on_intel do"
  lines << "      url #{resolved.fetch("darwin_amd64").fetch("url").inspect}"
  lines << "      sha256 #{resolved.fetch("darwin_amd64").fetch("sha256").inspect}"
  lines << "    end"
  lines << ""
end
lines << "    on_arm do"
lines << "      url #{resolved.fetch("darwin_arm64").fetch("url").inspect}"
lines << "      sha256 #{resolved.fetch("darwin_arm64").fetch("sha256").inspect}"
lines << "    end"
lines << "  end"
lines << ""
lines << "  on_linux do"
lines << "    on_intel do"
lines << "      url #{resolved.fetch("linux_amd64").fetch("url").inspect}"
lines << "      sha256 #{resolved.fetch("linux_amd64").fetch("sha256").inspect}"
lines << "    end"
lines << ""
lines << "    on_arm do"
lines << "      url #{resolved.fetch("linux_arm64").fetch("url").inspect}"
lines << "      sha256 #{resolved.fetch("linux_arm64").fetch("sha256").inspect}"
lines << "    end"
lines << "  end"
lines << ""
lines << "  def install"
lines << if archive_profile
  "    bin.install \"#{app}\""
else
  "    bin.install \"#{app}-\#{platform_suffix}\" => \"#{app}\""
end
lines << "  end"
lines << ""
caveat = caveats_for.call(app)
if caveat
  lines << "  def caveats"
  lines << "    <<~EOS"
  caveat.each_line { |line| lines << "      #{line.chomp}" }
  lines << "    EOS"
  lines << "  end"
  lines << ""
end
lines << "  test do"
test_args_for.call(app).each_with_index do |arg, index|
  prefix = index.zero? ? "    system bin/#{app.inspect}, " : " "
  suffix = (index == test_args_for.call(app).length - 1) ? "" : ","
  lines << "#{prefix}#{arg.inspect}#{suffix}"
end
lines << "  end"
unless archive_profile
  lines << ""
  lines << "  private"
  lines << ""
  lines << "  def platform_suffix"
  lines << "    return \"darwin-arm64\" if OS.mac? && Hardware::CPU.arm?"
  if resolved["darwin_amd64"]
    lines << "    return \"darwin-amd64\" if OS.mac?"
  else
    lines << ""
    lines << "    odie \"prebuilt macOS Intel binary is not published for #{app} \#{version}\" if OS.mac?"
  end
  lines << "    return \"linux-arm64\" if Hardware::CPU.arm?"
  lines << ""
  lines << "    \"linux-amd64\""
  lines << "  end"
end
lines << "end"

FileUtils.mkdir_p("Formula")
File.write(out_file, "#{lines.join("\n")}\n")
puts "updated #{out_file} -> v#{version}"
