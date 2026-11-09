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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.7/gonimbus-darwin-arm64"
      sha256 "d8759856653baeb320af7c861cc7021a89e05cdbc09bf89daa51286aeff75050"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.7/gonimbus-linux-amd64"
      sha256 "b170f38a6e12f94e652fcf187bf1b09b2890495f3668398f43539116f99db274"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.7/gonimbus-linux-arm64"
      sha256 "c75dfe5cf70e173c990a410049b892b31b81ed255016681f75dc040ddd38bcc5"
    end
  end

  def install
    bin.install "gonimbus-#{platform_suffix}" => "gonimbus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonimbus version")
    assert_match "\"version\":\"#{version}\"", shell_output("#{bin}/gonimbus version --json").gsub(/\s+/, "")
    unless build.head?
      assert_equal stable.checksum.hexdigest, Digest::SHA256.file((bin/"gonimbus").realpath).hexdigest
    end
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?

    odie "prebuilt macOS Intel binary is not published for gonimbus #{version}" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
