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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.3/gonimbus-darwin-arm64"
      sha256 "88d50837789f7d1a2e6c13345464c7d49624eb54e43c2cdac695eb1efb108e7c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.3/gonimbus-linux-amd64"
      sha256 "409827476dc2c8322720cf911af53df305d7ca9e56a0a6f0fe38d156acd18471"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.3/gonimbus-linux-arm64"
      sha256 "9a890ba10c731b50862c5307abe31aa4fd5f45e3e740c53dacb4c11a511b1845"
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
