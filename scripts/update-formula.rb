#!/usr/bin/env ruby
# typed: strict
# frozen_string_literal: true

require "json"
require "fileutils"
require "open3"

app = ARGV.fetch(0) { abort("usage: update-formula.rb <app>") }
repo = "3leaps/#{app}"
out_file = "Formula/#{app}.rb"

description_for = lambda do |name|
  {
    "kitfly"   => "Turn your writing into a website",
    "gonimbus" => "Cloud object storage crawl, inspect, and streaming CLI",
    "mdmeld"   => "Pack directory trees into markdown archives for AI sharing",
    "seclusor" => "Git-trackable secrets management with age encryption",
  }.fetch(name, "#{name} command-line tool")
end

test_args_for = lambda do |name|
  {
    "kitfly"   => ["--version"],
    "gonimbus" => ["version"],
    "mdmeld"   => ["--help"],
  }.fetch(name, ["--version"])
end

license_for = lambda do |name|
  {
    "gonimbus" => "Apache-2.0",
  }.fetch(name, "MIT")
end

release_json, release_error, release_status = Open3.capture3(
  "gh",
  "release",
  "view",
  "--repo",
  repo,
  "--json",
  "tagName,assets,name,isDraft,isPrerelease",
)
unless release_status.success?
  abort(release_error.empty? ? "error: failed to read latest release for #{repo}" : release_error)
end

release = JSON.parse(release_json)
if release["isDraft"] || release["isPrerelease"]
  abort("error: latest release for #{repo} is not a published stable release")
end

version = release.fetch("tagName").delete_prefix("v")
class_name = app.split(/[^a-zA-Z0-9]/).map(&:capitalize).join

assets = release.fetch("assets")
required = {
  "darwin_arm64" => "#{app}-darwin-arm64",
  "linux_amd64"  => "#{app}-linux-amd64",
  "linux_arm64"  => "#{app}-linux-arm64",
}
optional = {
  "darwin_amd64" => "#{app}-darwin-amd64",
}

resolved = required.transform_values do |asset_name|
  asset = assets.find { |item| item["name"] == asset_name }
  abort("error: missing release asset #{asset_name} for #{repo}") unless asset

  digest = asset["digest"].to_s.delete_prefix("sha256:")
  abort("error: missing sha256 digest for #{asset_name} in #{repo}") if digest.empty?

  { "url" => asset.fetch("url"), "sha256" => digest, "name" => asset_name }
end

optional.each do |key, asset_name|
  asset = assets.find { |item| item["name"] == asset_name }
  next unless asset

  digest = asset["digest"].to_s.delete_prefix("sha256:")
  abort("error: missing sha256 digest for #{asset_name} in #{repo}") if digest.empty?

  resolved[key] = { "url" => asset.fetch("url"), "sha256" => digest, "name" => asset_name }
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
lines << "    bin.install \"#{app}-\#{platform_suffix}\" => \"#{app}\""
lines << "  end"
lines << ""
lines << "  test do"
test_args_for.call(app).each_with_index do |arg, index|
  prefix = index.zero? ? "    system bin/#{app.inspect}, " : " "
  suffix = (index == test_args_for.call(app).length - 1) ? "" : ","
  lines << "#{prefix}#{arg.inspect}#{suffix}"
end
lines << "  end"
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
lines << "end"

FileUtils.mkdir_p("Formula")
File.write(out_file, "#{lines.join("\n")}\n")
puts "updated #{out_file} -> v#{version}"
