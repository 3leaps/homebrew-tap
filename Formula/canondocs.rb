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
      url "https://github.com/3leaps/canondocs/releases/download/v0.1.0/canondocs-darwin-arm64"
      sha256 "1bf263437d8ff598cc326558f2630bfc569292f832b2f4393ae2da331b230bc3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/3leaps/canondocs/releases/download/v0.1.0/canondocs-linux-amd64"
      sha256 "49166973e90f59350e30324a4f03b115fd06d6e80ba7f0975be14cd91ef0319e"
    end
    on_arm do
      url "https://github.com/3leaps/canondocs/releases/download/v0.1.0/canondocs-linux-arm64"
      sha256 "83411771f25c20e216804e2e6a9ab9592b468e814634ab54c28ebffa5825a762"
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
