class Mothership < Formula
  desc "Personal workspace for your work tools and Claude, Codex, and GPT agents"
  homepage "https://github.com/61uehigh/mothership"
  url "https://github.com/61uehigh/mothership/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "badde67460a1b586a86c24d6e5cec306b1772e280004ac58d1cc2852f2f32e5d"
  license "MIT"
  head "https://github.com/61uehigh/mothership.git", branch: "main"

  depends_on arch: :arm64
  depends_on "node" => :build
  depends_on :macos

  def install
    # The pnpm the project pins (Homebrew's own pnpm may be a newer major version).
    pnpm = JSON.parse(File.read("package.json"))["packageManager"]
    system "npx", "--yes", pnpm, "install", "--frozen-lockfile"
    system "npx", "--yes", pnpm, "app:build", "--dir"
    # Ad-hoc signed during the build: built on this Mac, so Gatekeeper doesn't need a Developer ID.
    # Homebrew rewrites library paths in the binaries it installs, which breaks Electron's frameworks
    # and the signature, so the app goes in as an archive and is unpacked after that step.
    libexec.mkpath
    system "tar", "-cf", libexec/"Mothership.app.tar", "-C", "dist/app/mac-arm64", "Mothership.app"

    (bin/"mothership").write <<~SH
      #!/bin/sh
      exec open "#{opt_prefix}/Mothership.app"
    SH
  end

  post_install_steps do
    if_path_exists "Mothership.app.tar", base: :libexec do
      remove "Mothership.app", base: :prefix, recursive: true
      run "/usr/bin/tar", args: ["-xf", "{{libexec}}/Mothership.app.tar", "-C", "{{prefix}}"],
                          writable_paths: ["."], writable_base: :prefix
      remove "Mothership.app.tar", base: :libexec
    end
  end

  def caveats
    <<~EOS
      Open Mothership with:
        mothership

      To find it in Launchpad and Spotlight, link it into Applications:
        ln -sf "#{opt_prefix}/Mothership.app" /Applications/Mothership.app

      Your settings and data live in ~/Library/Application Support/Mothership,
      so upgrading or reinstalling keeps them.
    EOS
  end

  test do
    assert_predicate prefix/"Mothership.app/Contents/MacOS/Mothership", :executable?
    system "codesign", "--verify", "--deep", prefix/"Mothership.app"
  end
end
