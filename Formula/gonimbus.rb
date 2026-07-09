class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.4.0"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.0/gonimbus-darwin-arm64"
      sha256 "69dc8247a538dd932d7515965e222eed1a615726789887d4362ba2a4c135030c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.0/gonimbus-linux-amd64"
      sha256 "643d1a1f2ee1e55e9e9900ccffc2864bfa2e966f952d03b7cff33f9955604235"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.0/gonimbus-linux-arm64"
      sha256 "fd94c87e468875bf437900c1b1b9ddcd191e9f4df058311b79afe882a1cf07ff"
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
