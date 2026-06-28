class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.3.4"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.4/gonimbus-darwin-arm64"
      sha256 "f8539206668017ca4484dd19ca7476350c6b197feec590016c139c039fdfb92c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.4/gonimbus-linux-amd64"
      sha256 "4425c4219cca277cc486beaeb64f60675a1aeb260d450fa07a3a9643cf899c3c"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.4/gonimbus-linux-arm64"
      sha256 "b9fa3d23f09e197a1c7fe4e219051fa9d23cfe0ebefc65727c56cfcfe0da9969"
    end
  end

  def install
    bin.install "gonimbus-#{platform_suffix}" => "gonimbus"
  end

  test do
    system bin/"gonimbus", "version"
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?

    odie "prebuilt macOS Intel binary is not published for gonimbus #{version}" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
