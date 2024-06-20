class CelestAT017 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.7"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.7/celest-0.1.7-macos_arm64.pkg"
      sha256 "8256708b3fd82c67bc2a8916d2156b654ed2d48df0b4f65aa117f547aae582da"
    else
      url "https://releases.celest.dev/macos_x64/0.1.7/celest-0.1.7-macos_x64.pkg"
      sha256 "e1ef6caa4c6a9e7c501b9a929ade694c2bcd29c8267e0166a24d51c87698cb07"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.7/celest-0.1.7-linux_arm64.deb"
      sha256 "da40756a0f87bcd809dbf7256173fad410fff90580aa88f48ccefa8426d6196b"
    else
      url "https://releases.celest.dev/linux_x64/0.1.7/celest-0.1.7-linux_x64.deb"
      sha256 "5dedcfcd36fa9d2825329ed750739f77def17def00940fe80de83c120fdeb8be"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.7-macos_arm64.pkg"
                 else
                   "celest-0.1.7-macos_x64.pkg"
                 end

      # Move the .pkg file to the Cellar for accessibility
      (prefix/"celest").install pkg_file
      # Use `open` to start the installer
      system "open", prefix/"celest"/pkg_file
    elsif OS.linux?
      # add a shell script to run dpkg -i
      (bin/"install.sh").write <<~EOS
        #!/bin/bash
        sudo dpkg -i #{cached_download}
      EOS

      system "chmod", "+x", bin/"install.sh"
      system "sudo", bin/"install.sh"
    end
  end

  def caveats
    <<~EOS
      This formula installs a package that requires root privileges.
      You may be prompted to enter your password to allow installation.
    EOS
  end

  test do
    system "#{bin}/celest", "--version"
  end
end
