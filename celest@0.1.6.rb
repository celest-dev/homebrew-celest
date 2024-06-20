class CelestAT016 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.6"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.6/celest-0.1.6-macos_arm64.pkg"
      sha256 "4482e9da26bcd9c2ca3363905eced376aaeff5e82e8dfa8363627130b0081a65"
    else
      url "https://releases.celest.dev/macos_x64/0.1.6/celest-0.1.6-macos_x64.pkg"
      sha256 "5c591068f5a346ee2d3cac70aafe4baef08aef2d24c50bd74028efcec99a83e9"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.6/celest-0.1.6-linux_arm64.deb"
      sha256 "ec983c25c8ee7278d055b673035288fc19e0ed316622e67d64238e7878e1b62d"
    else
      url "https://releases.celest.dev/linux_x64/0.1.6/celest-0.1.6-linux_x64.deb"
      sha256 "65a2e9036556edcb265f5111a27f0cd66d3c98e6bbe5490ad54d7b4ca7770711"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.6-macos_arm64.pkg"
                 else
                   "celest-0.1.6-macos_x64.pkg"
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
