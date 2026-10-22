class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  license "Apache-2.0"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/gonimbus.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.5/gonimbus-darwin-arm64"
      sha256 "ffccd63ba31f52b7456946281d9a5e86bbc2d37df31abe9dd3408a7ca4e00802"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.5/gonimbus-linux-amd64"
      sha256 "9b04bbd3735f850d1524479bb149f1ed65af9a967f72882134a40f41b6dd2c6d"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.5/gonimbus-linux-arm64"
      sha256 "a7e1009e2d690c4585cec7c0612d226e75d21601f00088d51c4d2604ed5030b7"
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
