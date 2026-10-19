class Spanwit < Formula
  desc "Context-aware disk-space diagnostics and safe reclamation"
  homepage "https://github.com/3leaps/spanwit"
  license "MIT"

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/spanwit.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.2/spanwit_0.2.2_darwin_arm64.tar.gz"
      sha256 "74fac2bb874ef1df5f25f8b4b895c8c2fd1ba1926c189dea77b354bcf8ca8fa0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.2/spanwit_0.2.2_linux_amd64.tar.gz"
      sha256 "26b2adeb5c02a6bf9be9f64d36108029946a728087b305ead8dfaa886440330a"
    end

    on_arm do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.2/spanwit_0.2.2_linux_arm64.tar.gz"
      sha256 "62283c9ae4d4b64593fe1f4a40ed45eaab926a311cc738af4f449d8234b54286"
    end
  end

  def install
    bin.install "spanwit"
  end

  def caveats
    <<~EOS
      spanwit prune is a dry run unless you pass --execute; only then does it delete anything.
      Usage and safety model: https://github.com/3leaps/spanwit#readme
    EOS
  end

  test do
    system bin/"spanwit", "version"
  end
end
