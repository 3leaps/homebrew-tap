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
      url "https://github.com/3leaps/yamlprims/releases/download/v0.2.2/yamlprims-0.2.2-darwin-arm64.tar.gz"
      sha256 "8cbf37fff33719740cdc460b4840e7cdc288ec69bf68041a5cceba0dc52e29c3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.2.2/yamlprims-0.2.2-linux-amd64.tar.gz"
      sha256 "230e57719bda85f5f489cccb271d5e821ecdb399979001cb3fb3ab44af49c3a5"
    end

    on_arm do
      url "https://github.com/3leaps/yamlprims/releases/download/v0.2.2/yamlprims-0.2.2-linux-arm64.tar.gz"
      sha256 "09f05681bd8ba82646b919a4dbb11a26296802d7f67d9d11f40f42da5254dd8b"
    end
  end

  def install
    bin.install "yamlprims"
  end

  test do
    system bin/"yamlprims", "--version"
  end
end
