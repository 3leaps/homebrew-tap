class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.3.7"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.7/gonimbus-darwin-arm64"
      sha256 "1cfe685a6accd998b4d6d1ca5888189f5baa2b7aa0590e0f9fc3a7044ec2bba1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.7/gonimbus-linux-amd64"
      sha256 "0c57b55cb6ef3a50b61ee11c749b8b47a9bb7b1d327fffd0443e972a367962f0"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.7/gonimbus-linux-arm64"
      sha256 "cb9dd05a261953542d02957810965aaaa96c9cd1a0f847233646cfb1fcf17fff"
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
