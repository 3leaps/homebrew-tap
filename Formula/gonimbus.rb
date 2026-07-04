class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.3.5"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.5/gonimbus-darwin-arm64"
      sha256 "b9251525fe7db2a0ba7f3ed9e5b46aac915fb559dfc377a100440543821e61be"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.5/gonimbus-linux-amd64"
      sha256 "40974d11d2ed73ce0844169b660288bc1fb1defbbe03a65537b2190e73903750"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.5/gonimbus-linux-arm64"
      sha256 "180a81bec62b3aaa29bc072b8ce7c021c7f2054890ed549b203255546fcda1bb"
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
