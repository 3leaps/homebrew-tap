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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.5.1/gonimbus-darwin-arm64"
      sha256 "24e2bd826ea296b8343a83d59ba21d4dfea367f6f66e0c0b710ed812843d622a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.5.1/gonimbus-linux-amd64"
      sha256 "519648c1480e5303d6308e9eba69a44805cf41e9f533dd67e2ddf98449cb30e7"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.5.1/gonimbus-linux-arm64"
      sha256 "99610ca6a4f93f3e0f03439b359a09c9f5c832fc4904d5c050b45f4a2d82d051"
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
