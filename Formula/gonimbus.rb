class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.3.3"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.3/gonimbus-darwin-arm64"
      sha256 "1ac2ce94af9855ad83981d014c9295b0d309830cb3ca481a96a00c69c45b5be6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.3/gonimbus-linux-amd64"
      sha256 "3f541f71759117a31f6e8167073f038da418d0642bc6f91ac2504314adef2eaf"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.3/gonimbus-linux-arm64"
      sha256 "1602771d42bf6f9e17875f98d621795c7a65d5ab2b29ec221c01994cee107d61"
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
