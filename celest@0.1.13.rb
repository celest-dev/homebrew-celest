class CelestAT0113 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.13"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.13/celest-0.1.13-macos_arm64.pkg"
      sha256 "eff6e734be74ee1fa99cf0e41f470dd3eb01526b148fe472b16ec4e0a7032ea0"
    else
      url "https://releases.celest.dev/macos_x64/0.1.13/celest-0.1.13-macos_x64.pkg"
      sha256 "968e20b6680c37b4a91f5b29f95dc1929cebf096569337b9f5c94849a7173497"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.13/celest-0.1.13-linux_arm64.deb"
      sha256 "04e7e354a1afa63c5cf9444e68dd05087b757ee0c4d081aa8a2560b99718ddc1"
    else
      url "https://releases.celest.dev/linux_x64/0.1.13/celest-0.1.13-linux_x64.deb"
      sha256 "73392d14bb946747901b5aa9ac5e5d5b2548a9f67f014538919c8ee318e9d021"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.13-macos_arm64.pkg"
                 else
                   "celest-0.1.13-macos_x64.pkg"
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
