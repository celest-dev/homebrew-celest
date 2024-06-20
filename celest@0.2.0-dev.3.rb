class CelestAT020dev3 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0-dev.3"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0-dev.3/celest-0.2.0-dev.3-macos_arm64.pkg"
      sha256 "1d29de5fb5581555e000eec171e13a2ddb7c35e8c847b9ea4bd9eec8527c8b17"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0-dev.3/celest-0.2.0-dev.3-macos_x64.pkg"
      sha256 "4e6f2895b1e6ddb11d4e8f63f4427ca81a29e73207a9b2ec4cf874e3ef2431d9"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0-dev.3/celest-0.2.0-dev.3-linux_arm64.deb"
      sha256 "0f6c5c7e7710631b11afa0796d0e56152bf652d668b5add43538aba242e99472"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0-dev.3/celest-0.2.0-dev.3-linux_x64.deb"
      sha256 "e691d63881413af110ea3ae5541aaea8b621226862f6eeec6541eac3ab8d107b"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-dev.3-macos_arm64.pkg"
                 else
                   "celest-0.2.0-dev.3-macos_x64.pkg"
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
