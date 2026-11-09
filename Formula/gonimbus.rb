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
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.6/gonimbus-darwin-arm64"
      sha256 "317b28d1fb83707c7b7f2079b9beb3b3782559fdfccab542f39bda5265ca8e9d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.6/gonimbus-linux-amd64"
      sha256 "57334a7f7afed7c0822e16a3027d0fa717a4e3778886b3a0eb2acf7ae925daf1"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.4.6/gonimbus-linux-arm64"
      sha256 "99669a57ca50a0918f39bf0cad2307429e54bd53ab1c93cf0220fdc6f81e6acd"
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
