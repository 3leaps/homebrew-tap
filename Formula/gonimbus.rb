class Gonimbus < Formula
  desc "Cloud object storage crawl, inspect, and streaming CLI"
  homepage "https://github.com/3leaps/gonimbus"
  version "0.3.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.2/gonimbus-darwin-arm64"
      sha256 "c27606215bd7980137824b48a30fac655f1a6d1269043c2a11e995960d6bce3c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.2/gonimbus-linux-amd64"
      sha256 "dd91cc8e788b6fa8fde81153d94807edcf72515c93a9e950136964e9be5149cb"
    end

    on_arm do
      url "https://github.com/3leaps/gonimbus/releases/download/v0.3.2/gonimbus-linux-arm64"
      sha256 "1d40b95ae1240e77815010656c4a4e4ae30df0a695097dbcd9d95942a659f5c9"
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
