class CelestAT021 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.1/celest-0.2.1-macos_arm64.pkg"
      sha256 "994585d5c0e2da62edcba75ae3810cb053918438adda569298584fbe90e9551b"
    else
      url "https://releases.celest.dev/macos_x64/0.2.1/celest-0.2.1-macos_x64.pkg"
      sha256 "fb6f204a31c25599adccf2a54c4f451d4a849f3356122c24f0970308bf3bb56b"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.1/celest-0.2.1-linux_arm64.deb"
      sha256 "8f5387145b6156a3f6f264d32aa8db9cb4a75dde6f577d4721942a0e6f639fc0"
    else
      url "https://releases.celest.dev/linux_x64/0.2.1/celest-0.2.1-linux_x64.deb"
      sha256 "b431b5bf585157f81a1587824f3b2845a797126b4d360a57270d84679d4304d5"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.1-macos_arm64.pkg"
                 else
                   "celest-0.2.1-macos_x64.pkg"
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
