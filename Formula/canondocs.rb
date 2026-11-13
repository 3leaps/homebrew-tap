class Canondocs < Formula
  desc "RFC 8785 canonical JSON from JSON, YAML and NDJSON"
  homepage "https://github.com/3leaps/canondocs"
  license any_of: ["MIT", "Apache-2.0"]

  # No darwin-amd64 binary is published. The head spec gives unsupported
  # platforms a buildable fallback and keeps tap-wide readall checks valid.
  head "https://github.com/3leaps/canondocs.git", branch: "main"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/3leaps/canondocs/releases/download/v0.1.1/canondocs-darwin-arm64"
      sha256 "6cd63b7d372421e665ea9ce50fc71d32516300b40af795535368126b78bd7ec6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/canondocs/releases/download/v0.1.1/canondocs-linux-amd64"
      sha256 "d539e23d4714f6df013039a349ce9ba70baf47b35a279099dd3075628f1e7c21"
    end
    on_arm do
      url "https://github.com/3leaps/canondocs/releases/download/v0.1.1/canondocs-linux-arm64"
      sha256 "8529880240bddcaba24f002980da6af4a0bb16b7fb3ee56d6580af6fc2d5f972"
    end
  end

  def install
    if OS.mac?
      bin.install "canondocs-darwin-arm64" => "canondocs"
    elsif Hardware::CPU.arm?
      bin.install "canondocs-linux-arm64" => "canondocs"
    else
      bin.install "canondocs-linux-amd64" => "canondocs"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/canondocs version")
  end
end
