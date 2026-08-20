class Seclusor < Formula
  desc "Git-trackable secrets management with age encryption"
  homepage "https://github.com/3leaps/seclusor"
  license "MIT"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/seclusor.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.2/seclusor-darwin-arm64"
      sha256 "4dae5a1baf1045b95fe8393ac0a1e4d4671b9cae719a652f59ed4397a21510e5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.2/seclusor-linux-amd64"
      sha256 "5521d5aba4fb5422c7fdacc3fc7c9a6c462de125970c0e8fb9838329468c3741"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.2/seclusor-linux-arm64"
      sha256 "d03cf4bfd16700fb8c2715d1d060704030ec78f84c1538f65072b8b2863baab8"
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
