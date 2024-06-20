class CelestAT044 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.4.4"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.4.4/celest-0.4.4-macos_arm64.pkg"
      sha256 "ad773046d27bac58be273a0a7d0455f5a9c3515d5c8a23e14d507027f67b150c"
    else
      url "https://releases.celest.dev/macos_x64/0.4.4/celest-0.4.4-macos_x64.pkg"
      sha256 "ef515619243f6bc7dc27373e14d350e6a8912da63a39156d35a1787574a7a805"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.4.4/celest-0.4.4-linux_arm64.deb"
      sha256 "ccc2a3c514756022e566b6d7cf0054791219d09f775b9ccd3acfbf526e9664dd"
    else
      url "https://releases.celest.dev/linux_x64/0.4.4/celest-0.4.4-linux_x64.deb"
      sha256 "b6839ab36fe015bcfb37403badf34fa310a75e81f123479627dc8a1ba7f725d3"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.4.4-macos_arm64.pkg"
                 else
                   "celest-0.4.4-macos_x64.pkg"
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
