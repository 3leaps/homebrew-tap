#!/usr/bin/env bash
set -euo pipefail

APP="${1:?usage: update-formula.sh <app>}"
REPO="3leaps/${APP}"
OUT_FILE="Formula/${APP}.rb"

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI is required" >&2
  exit 1
fi

if ! command -v ruby >/dev/null 2>&1; then
  echo "error: ruby is required" >&2
  exit 1
fi

mkdir -p Formula

release_json="$(gh release view --repo "${REPO}" --json tagName,assets,name,isDraft,isPrerelease)"

ruby - "${APP}" "${REPO}" "${OUT_FILE}" "${release_json}" <<'RUBY'
require "json"

app = ARGV[0]
repo = ARGV[1]
out_file = ARGV[2]
release = JSON.parse(ARGV[3])

description_for = lambda do |name|
  {
    "kitfly" => "Turn your writing into a website",
    "gonimbus" => "Cloud object storage crawl, inspect, and streaming CLI",
    "mdmeld" => "Pack directory trees into markdown archives for AI sharing",
  }.fetch(name, "#{name} command-line tool")
end

test_args_for = lambda do |name|
  {
    "kitfly" => ["--version"],
    "gonimbus" => ["version"],
    "mdmeld" => ["--help"],
  }.fetch(name, ["--version"])
end

if release["isDraft"] || release["isPrerelease"]
  abort("error: latest release for #{repo} is not a published stable release")
end

version = release.fetch("tagName").sub(/\Av/, "")
class_name = app.split(/[^a-zA-Z0-9]/).map(&:capitalize).join

assets = release.fetch("assets")
required = {
  "darwin_arm64" => "#{app}-darwin-arm64",
  "linux_amd64" => "#{app}-linux-amd64",
  "linux_arm64" => "#{app}-linux-arm64",
}
optional = {
  "darwin_amd64" => "#{app}-darwin-amd64",
}

resolved = required.transform_values do |asset_name|
  asset = assets.find { |item| item["name"] == asset_name }
  abort("error: missing release asset #{asset_name} for #{repo}") unless asset
  digest = asset["digest"].to_s.sub(/\Asha256:/, "")
  abort("error: missing sha256 digest for #{asset_name} in #{repo}") if digest.empty?
  { "url" => asset.fetch("url"), "sha256" => digest, "name" => asset_name }
end

optional.each do |key, asset_name|
  asset = assets.find { |item| item["name"] == asset_name }
  next unless asset

  digest = asset["digest"].to_s.sub(/\Asha256:/, "")
  abort("error: missing sha256 digest for #{asset_name} in #{repo}") if digest.empty?
  resolved[key] = { "url" => asset.fetch("url"), "sha256" => digest, "name" => asset_name }
end

lines = []
lines << "class #{class_name} < Formula"
lines << "  desc #{description_for.call(app).inspect}"
lines << "  homepage \"https://github.com/#{repo}\""
lines << "  version #{version.inspect}"
lines << "  license \"MIT\""
lines << ""
lines << "  on_macos do"
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
  lines << "#{prefix}#{arg.inspect}#{index == test_args_for.call(app).length - 1 ? "" : ","}"
end
lines << "  end"
lines << ""
lines << "  private"
lines << ""
lines << "  def platform_suffix"
lines << "    return \"darwin-arm64\" if OS.mac? && Hardware::CPU.arm?"
lines << "    return \"darwin-amd64\" if OS.mac?"
lines << "    return \"linux-arm64\" if Hardware::CPU.arm?"
lines << ""
lines << "    \"linux-amd64\""
lines << "  end"
lines << "end"

File.write(out_file, "#{lines.join("\n")}\n")
puts "updated #{out_file} -> v#{version}"
RUBY
