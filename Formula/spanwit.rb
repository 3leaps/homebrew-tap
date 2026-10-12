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
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.1/spanwit_0.2.1_darwin_arm64.tar.gz"
      sha256 "84e2f5eceb6043d1a84e96bb8e28b8d13b6949d8f05c3db552729c49e4461c3a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.1/spanwit_0.2.1_linux_amd64.tar.gz"
      sha256 "5156ca3bab556041eb2fc33053d7d8c2f7810d3f21fcaa428257d98d467ea078"
    end

    on_arm do
      url "https://github.com/3leaps/spanwit/releases/download/v0.2.1/spanwit_0.2.1_linux_arm64.tar.gz"
      sha256 "caa7345bca9e87e449ab2f6c958c319cf3b1cb8aee362da557cc0ea20e985f08"
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
