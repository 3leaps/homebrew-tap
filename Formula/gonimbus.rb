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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.2/gonimbus-darwin-arm64"
      sha256 "e4e66685b648b9efab03c49c1c05e4591e9ad2d5496ec01121f3bf8ba59f196c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.2/gonimbus-linux-amd64"
      sha256 "a9e96a05e0c6c51a5ab26be923171398027f3764318b0e89eb4e4174a7fff1af"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.2/gonimbus-linux-arm64"
      sha256 "6e5d39f2bd5c20d227fdb42855e9c274a8c2f7aa4704569beae1ca34aed42d8c"
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
