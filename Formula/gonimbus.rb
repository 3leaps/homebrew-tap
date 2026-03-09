class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.1.7"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.1.7/gonimbus-darwin-amd64"
      sha256 "3d53ea8ef3c3bda18c4bf20f0b2c5318a1eb25937477985967b983e4525ee4ca"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.1.7/gonimbus-darwin-arm64"
      sha256 "3d1c6ff9b71f82e76e5cc3f40c3e2a5e41dec49f6e2a8aa8acb5187ef44960a1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.1.7/gonimbus-linux-amd64"
      sha256 "b199f688f870978afa9309bee16021d53feed912acd87348eb2567735abe94d2"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.1.7/gonimbus-linux-arm64"
      sha256 "8f278ecc3535f49b0aa5aba4985e0da7cdc2e0f829d28fdad5c15e8493d3e26d"
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
    return "darwin-amd64" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
