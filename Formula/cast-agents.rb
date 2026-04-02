class CastAgents < Formula
  desc "17 specialist Claude Code agents — commit, debug, review, plan, and more"
  homepage "https://github.com/ek33450505/cast-agents"
  url "https://github.com/ek33450505/cast-agents/archive/refs/heads/main.tar.gz"
  version "0.1.0"
  sha256 "9e6287523f3fcb9226160f031b7c96d4c2d953ec6a32bbf9b03b5c9f869cafdb"
  license "MIT"

  def install
    libexec.install Dir["agents/*"]
    libexec.install Dir["examples/*"]
    (libexec/"VERSION").write(File.read("VERSION"))
    prefix.install "VERSION"

    inreplace "bin/cast-agents",
              'CAST_AGENTS_DIR=""',
              "CAST_AGENTS_DIR=\"#{libexec}\""

    inreplace "bin/cast-agents",
              /CA_VERSION="\$\(cat.*\|\| echo .unknown.\)"/,
              "CA_VERSION=\"#{version}\""

    bin.install "bin/cast-agents"
  end

  def caveats
    <<~EOS
      Install agents to ~/.claude/agents/:
        cast-agents install

      Then in Claude Code, dispatch any agent:
        "Use the code-reviewer agent to review my changes"

      List all available agents:
        cast-agents list
    EOS
  end

  test do
    system "#{bin}/cast-agents", "--version"
  end
end
