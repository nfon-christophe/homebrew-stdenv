require_relative "../std_requirements/std_mono_requirement"

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/docfx.rb
class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.49/docfx.zip"
  sha256 "256187a1c6ac0e4fce557e3049a89417010d8c2a09d4dd3cc54c285c4765f2a0"

  bottle :unneeded

  depends_on "mono" => :optional # Make mono optional so it's not installed by default & we get --with-mono
  depends_on StdMonoRequirement => [build.with?("mono"), :build] # StdMonoRequirement looks for mono in std environment

  def install
    libexec.install Dir["*"]

    (bin/"docfx").write <<~EOS
      #!/bin/bash
      mono #{libexec}/docfx.exe "$@"
    EOS
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
