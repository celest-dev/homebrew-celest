class CelestAT041 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.4.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.4.1/celest-0.4.1-macos_arm64.pkg"
      sha256 "a3e2bbe47b2ecf757080aea6fb097fe058cdc56881959191dbadf92b912615fe"
    else
      url "https://releases.celest.dev/macos_x64/0.4.1/celest-0.4.1-macos_x64.pkg"
      sha256 "c69e86c4c3db7be872fda64f6de4fa335f1c2dd03e0cc89f9fef2d711053b38e"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.4.1/celest-0.4.1-linux_arm64.deb"
      sha256 "23dc5fc904bfca723d5d720de345f93b06b2408388cfd83e1053f609c3be3060"
    else
      url "https://releases.celest.dev/linux_x64/0.4.1/celest-0.4.1-linux_x64.deb"
      sha256 "19a4d7502536f8f3ece258eeefa2593e866d9dd30a7817d212fcbb4379a1ee03"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.4.1-macos_arm64.pkg"
                 else
                   "celest-0.4.1-macos_x64.pkg"
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
