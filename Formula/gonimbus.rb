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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.5.0/gonimbus-darwin-arm64"
      sha256 "666072b41b5f323637ed30cf82025d43e0c11b4c5698e57c4d84642e198a7bc8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.5.0/gonimbus-linux-amd64"
      sha256 "18d4c7ca6fb7b6e3b7b0a2be38489e590818ee8a1743d28ce13ae0b01b9f549b"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.5.0/gonimbus-linux-arm64"
      sha256 "ad8bd57531ed3225102cee41331e555d724ea12200edf41741355791649d715a"
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
