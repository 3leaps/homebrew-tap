class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.3.6"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.6/gonimbus-darwin-arm64"
      sha256 "2bbf4d951249fd5f5a57ae55fe91aa81e18fb106fde8445b989abac78b7f8fa3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.6/gonimbus-linux-amd64"
      sha256 "9677c6d69a8e7fe4d020285b1ed940679f61df827e469547fc24a78d7a6d07f2"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.6/gonimbus-linux-arm64"
      sha256 "e4633a8fd060d5e579a8cacd45d8f8afd146d42b8ea995a9cd2925fcaf79913b"
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
