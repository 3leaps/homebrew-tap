class Kitfly < Formula
  desc "Turn your writing into a website"
  homepage "https://github.com/3leaps/kitfly"
  license "MIT"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/kitfly.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.5/kitfly-darwin-arm64"
      sha256 "a8f53c50a490a4ab6ca5a05ee8be643ea0f2d6f201fff2d35346fae5216e6a5c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.5/kitfly-linux-amd64"
      sha256 "f2972add18feac43245704f7eced8e5c131e75f1f67cd8055280a0df84642b02"
    end

    on_arm do
      url "https://github.com/3leaps/kitfly/releases/download/v0.2.5/kitfly-linux-arm64"
      sha256 "4c589864a61e8031594cb928f945fbd919a3dfe9162c613f1dc7e2865c6f7890"
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

    odie "prebuilt macOS Intel binary is not published for kitfly #{version}" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
