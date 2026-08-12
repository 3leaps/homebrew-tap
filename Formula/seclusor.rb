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
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.1/seclusor-darwin-arm64"
      sha256 "af24bc3415483564742cfe5b844c522a419c7770184809f959beee6461b64cdc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.1/seclusor-linux-amd64"
      sha256 "341f80ccb7d30df1efdfc582cf382a3a7a653a783f9f43dd171a9e094ad6f964"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.1/seclusor-linux-arm64"
      sha256 "1ff787dc8618d2a9653daf0ad4d2f3bf1c87e7bd0f728cb7cb70a63cb8aac581"
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
