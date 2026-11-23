class Yamlprims < Formula
  desc "Memory-safe YAML 1.2 Core reader, writer and I-JSON projection"
  homepage "https://github.com/3leaps/yamlprims"
  license any_of: ["MIT", "Apache-2.0"]

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/yamlprims.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.3.1/yamlprims-0.3.1-darwin-arm64.tar.gz"
      sha256 "b3a5be62ad37d95db37c4d845146532e5b094145ec0d625768ca9d0d6fd218fc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.3.1/yamlprims-0.3.1-linux-amd64.tar.gz"
      sha256 "8730a1053d288bab449e5446212c718731e5408eaaf0235475faa49c2eb81bc2"
    end

    on_arm do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.3.1/yamlprims-0.3.1-linux-arm64.tar.gz"
      sha256 "7efeb350c0d443171796f952056bf16e36876492730e2d19190c9d3386ef207e"
    end
  end

  def install
    bin.install "yamlprims"
  end

  test do
    system bin/"yamlprims", "--version"
  end
end
