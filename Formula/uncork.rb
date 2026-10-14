class Uncork < Formula
  desc "Drag-and-drop .exe launcher for macOS, powered by Wine"
  homepage "https://github.com/61uehigh/uncork"
  url "https://github.com/61uehigh/uncork/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "55fbf04e71d965d480b96088bbc3fc43ef50f800cc827acc9de9f031ced93910"
  license "MIT"
  head "https://github.com/61uehigh/uncork.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # Homebrew already sandboxes the build, and SwiftPM can't start its own sandbox inside it.
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin_path = Utils.safe_popen_read("swift", "build", "--configuration", "release", "--show-bin-path").chomp

    app = prefix/"Uncork.app/Contents"
    (app/"MacOS").install "#{bin_path}/Uncork"
    app.install "Resources/Info.plist"
    (app/"Resources").install "Resources/AppIcon.icns"
    # Ad-hoc signature: built on this Mac, so Gatekeeper doesn't need a Developer ID.
    system "codesign", "--force", "--sign", "-", prefix/"Uncork.app"

    # `uncork program.exe` opens the program in the app, the same as dropping it on the window.
    (bin/"uncork").write <<~SH
      #!/bin/sh
      if [ "$#" -eq 0 ]; then
        exec open "#{opt_prefix}/Uncork.app"
      fi
      exec open -a "#{opt_prefix}/Uncork.app" "$@"
    SH
  end

  def caveats
    <<~EOS
      Open Uncork with:
        open "#{opt_prefix}/Uncork.app"

      To find it in Launchpad and Spotlight, link it into Applications:
        ln -sf "#{opt_prefix}/Uncork.app" /Applications/Uncork.app

      Uncork downloads its Wine runtime (about 185 MB) the first time you open a Windows program.
      On Apple Silicon it also needs Rosetta 2.
    EOS
  end

  test do
    assert_predicate prefix/"Uncork.app/Contents/MacOS/Uncork", :executable?
    plist = prefix/"Uncork.app/Contents/Info.plist"
    bundle_id = shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' #{plist}")
    assert_match "io.github.61uehigh.uncork", bundle_id
  end
end
