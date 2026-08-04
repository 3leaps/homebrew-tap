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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.1/gonimbus-darwin-arm64"
      sha256 "5f91a8f9959edb3c5cc43c38ec60b694529455bfc2746befda8fa862e2739229"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.1/gonimbus-linux-amd64"
      sha256 "6194b6a4728e7afc662298a32e304ec2dbc6d6911c3074c7d13ad995ce07030b"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.1/gonimbus-linux-arm64"
      sha256 "6f30a04b2fd86799188c9be03584816cc742d5ad952d44a18ff727004a8da044"
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
