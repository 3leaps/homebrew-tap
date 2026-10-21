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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.4/gonimbus-darwin-arm64"
      sha256 "ab18ec247e05b7e885ee2d5eff30f3337898eec421ae724787a74234d95d1124"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.4/gonimbus-linux-amd64"
      sha256 "7fe8d121ef14e8f75567868175bb5aec8361ee84f940ccecdc5868fa6bf1287c"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.4/gonimbus-linux-arm64"
      sha256 "1c2adcdc36829cd216db17d709fb7cae327853197a7e340b21d18f4cace45b31"
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
