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
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.0/spanwit_0.2.0_darwin_arm64.tar.gz"
      sha256 "3b6342342570fa1e7fb73c3602c162cc44eed3c98f0caaf23f22372967376877"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.0/spanwit_0.2.0_linux_amd64.tar.gz"
      sha256 "9b67d68bd67718c3561610b818ce5b8918ba02c046f11e9485f4fffe2f546acc"
    end

    on_arm do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.0/spanwit_0.2.0_linux_arm64.tar.gz"
      sha256 "f3bd2e4ba49dd74f05d25d36df68bca42dd88184e03c050503f9369480cc6ad0"
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
