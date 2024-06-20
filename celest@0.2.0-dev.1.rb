class CelestAT020dev1 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0-dev.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0-dev.1/celest-0.2.0-dev.1-macos_arm64.pkg"
      sha256 "3a824e887412cc1432ec948b3942e784b9d123447db914159217547e22c39486"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0-dev.1/celest-0.2.0-dev.1-macos_x64.pkg"
      sha256 "eec6bb2bcb95e47129b7a102d4770abb1180d6f53fb23cedf10f4a42f05b3ce4"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0-dev.1/celest-0.2.0-dev.1-linux_arm64.deb"
      sha256 "1645dc4c34ff95df80088bbbefee57d7d1bf57540f8323d7c65713dca883836b"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0-dev.1/celest-0.2.0-dev.1-linux_x64.deb"
      sha256 "f34349854caa023d0b783277865773e3c47021ec79a81f4006d3c4376b6b679f"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-dev.1-macos_arm64.pkg"
                 else
                   "celest-0.2.0-dev.1-macos_x64.pkg"
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
