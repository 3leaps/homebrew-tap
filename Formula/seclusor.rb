class Seclusor < Formula
  desc "Git-trackable secrets management with age encryption"
  homepage "https://github.com/3leaps/seclusor"
  license any_of: ["MIT", "Apache-2.0"]

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/seclusor.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.3/seclusor-darwin-arm64"
      sha256 "fffee444c15c971dfb9b3ee5db1ad919f6b66ad888cbd0bc693be2f52f7353bf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.3/seclusor-linux-amd64"
      sha256 "5c5a555bf07b4a0bebadba3c5ed25cca5d581091c1181535f8bbef27f8d3910a"
    end

    on_arm do
      url "https://github.com/3leaps/seclusor/releases/download/v0.2.3/seclusor-linux-arm64"
      sha256 "449639e6df4f21aa6c4a431b03fc5d54f1adcdeb6506741c6d75f771d3fdf16c"
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
