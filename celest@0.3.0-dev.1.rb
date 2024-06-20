class CelestAT030dev1 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.0-dev.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.0-dev.1/celest-0.3.0-dev.1-macos_arm64.pkg"
      sha256 "64373c87872a9a85a940e10ceba5bc81a013020cce8ad2af0476dbe9c484f7b2"
    else
      url "https://releases.celest.dev/macos_x64/0.3.0-dev.1/celest-0.3.0-dev.1-macos_x64.pkg"
      sha256 "478c2175db2cf6cd855cc7cc7f508db9abac29ce1127d87b28cfe1c434a64c89"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.0-dev.1/celest-0.3.0-dev.1-linux_arm64.deb"
      sha256 "cdc94889f264aeca7ad50e43157c84c1070f3408ebeff265bf9c49311423891a"
    else
      url "https://releases.celest.dev/linux_x64/0.3.0-dev.1/celest-0.3.0-dev.1-linux_x64.deb"
      sha256 "785c50e8cf03abbd2d4b469874353a2632d08ba79e47b78215c244c3bd964491"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.0-dev.1-macos_arm64.pkg"
                 else
                   "celest-0.3.0-dev.1-macos_x64.pkg"
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
