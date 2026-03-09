class Kitfly < Formula
  desc "Turn your writing into a website"
  homepage "https://github.com/3leaps/kitfly"
  version "0.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.3/kitfly-darwin-arm64"
      sha256 "6a533c752dd5532c41b3273a98d106e1066d58ab687dce40b85bee737d85e308"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.3/kitfly-linux-amd64"
      sha256 "14ddd5138c3095e4500b2ba5279e6996d660f33d9ea587f1a24691469a4c712d"
    end

    on_arm do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.3/kitfly-linux-arm64"
      sha256 "13ebc994653d14b61d6847a8a189ff2e03dd2e03a55741cb71df2da3d86ae589"
    end
  end

  def install
    bin.install "kitfly-#{platform_suffix}" => "kitfly"
  end

  test do
    system bin/"kitfly", "--version"
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?
    return "darwin-amd64" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
