class CelestAT020dev2 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0-dev.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0-dev.2/celest-0.2.0-dev.2-macos_arm64.pkg"
      sha256 "614ef60caf8eba06669846da5710553c3278c42acfd1355e3e8d41a2c0687b3f"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0-dev.2/celest-0.2.0-dev.2-macos_x64.pkg"
      sha256 "3420aaaeb7478dfc26ca6e3e6cd9efb33b0fe729699e99f3fe61ac66fcd5fd51"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0-dev.2/celest-0.2.0-dev.2-linux_arm64.deb"
      sha256 "80401e0cf69359fa10799aeefeab05d33abded8ac20e2e722de069c1e78090d3"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0-dev.2/celest-0.2.0-dev.2-linux_x64.deb"
      sha256 "15c85b175f873314689c0697eaad0cd3504e62c27c99a6f025a9637ca1eb1a8d"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-dev.2-macos_arm64.pkg"
                 else
                   "celest-0.2.0-dev.2-macos_x64.pkg"
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
