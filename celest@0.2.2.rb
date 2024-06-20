class CelestAT022 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.2/celest-0.2.2-macos_arm64.pkg"
      sha256 "7ac6d7043126fca3ea665ed706fd0e2706545179adf2d6d564e8ddf63bb22c60"
    else
      url "https://releases.celest.dev/macos_x64/0.2.2/celest-0.2.2-macos_x64.pkg"
      sha256 "ce0d07aeb332e8f40ada3d43e85efeb251690cdf33b1fd25ddf25e46f3dec008"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.2/celest-0.2.2-linux_arm64.deb"
      sha256 "3d71c6ae57ea380ff1f02355bbbeec88c0491be37f7ab7ab3578d7a7b33953eb"
    else
      url "https://releases.celest.dev/linux_x64/0.2.2/celest-0.2.2-linux_x64.deb"
      sha256 "28daa851b56e1eecf53554e681f770609ebb24b43aef4464cbfb82796a9b1e20"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.2-macos_arm64.pkg"
                 else
                   "celest-0.2.2-macos_x64.pkg"
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
