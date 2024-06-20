class CelestAT047 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.4.7"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.4.7/celest-0.4.7-macos_arm64.pkg"
      sha256 "f3a61f0379c3bfa1b2da3c3945dcaaad1237a254e97f5219690a2f906d4136f0"
    else
      url "https://releases.celest.dev/macos_x64/0.4.7/celest-0.4.7-macos_x64.pkg"
      sha256 "a16a2b7b9f06f5bdd1dfd4dc9bdd5f234c706bb20847cb082900f2763283458b"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.4.7/celest-0.4.7-linux_arm64.deb"
      sha256 "ebfd7e15ab30165d2a7e21ee2ea5075af6f5801a206d9b06fcab0d4ac11f04b5"
    else
      url "https://releases.celest.dev/linux_x64/0.4.7/celest-0.4.7-linux_x64.deb"
      sha256 "75b6d8256c526b85b747a0356287cee7ed93bccdf9d915876e432837dee0ce66"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.4.7-macos_arm64.pkg"
                 else
                   "celest-0.4.7-macos_x64.pkg"
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
