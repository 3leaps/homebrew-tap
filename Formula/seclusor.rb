class Seclusor < Formula
  desc "Git-trackable secrets management with age encryption"
  homepage "https://github.com/3leaps/seclusor"
  version "0.2.0"
  license "MIT"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/seclusor.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.0/seclusor-darwin-arm64"
      sha256 "baab14f80d4856031f4f0139bbe86b86357b45a0a8c26f15dc332138052e6afe"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.0/seclusor-linux-amd64"
      sha256 "30dda325c1684b6c2c36f3589cf42adce9bc45eaf39bbf193e034bd5d472bbeb"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.0/seclusor-linux-arm64"
      sha256 "39af51859b092268f5c27e63791c5f930fa7d3c55aa0f37a0e2ba52ba7e8aaaf"
    end
  end

  def install
    bin.install "seclusor-#{platform_suffix}" => "seclusor"
  end

  test do
    system bin/"seclusor", "--version"
  end

  private

  def platform_suffix
    return "darwin-arm64" if OS.mac? && Hardware::CPU.arm?

    odie "prebuilt macOS Intel binary is not published for seclusor #{version}" if OS.mac?
    return "linux-arm64" if Hardware::CPU.arm?

    "linux-amd64"
  end
end
