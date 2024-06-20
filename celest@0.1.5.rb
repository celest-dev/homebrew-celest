class CelestAT015 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.5"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.5/celest-0.1.5-macos_arm64.pkg"
      sha256 "9f4dca8eaafe3b2f2641ed915cd424950c235bdb942df1092ed415e26034f034"
    else
      url "https://releases.celest.dev/macos_x64/0.1.5/celest-0.1.5-macos_x64.pkg"
      sha256 "f8b385e49dfb0ceb85334da02613af14556b938c911ed170dfe21d7a32db7782"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.5/celest-0.1.5-linux_arm64.deb"
      sha256 "06dfbdb9157282fa97169947da43edbf52bb3a4cde008a952ff072675fc91696"
    else
      url "https://releases.celest.dev/linux_x64/0.1.5/celest-0.1.5-linux_x64.deb"
      sha256 "f6a36fcc0943827f948c39ae847adb1ae64de716d4499d29481302e1be24343f"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.5-macos_arm64.pkg"
                 else
                   "celest-0.1.5-macos_x64.pkg"
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
