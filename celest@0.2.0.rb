class CelestAT020 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0/celest-0.2.0-macos_arm64.pkg"
      sha256 "bed5f3e24026a17f16a6dc3c046a130433a455078bf28090b2ec867ef30b2bbf"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0/celest-0.2.0-macos_x64.pkg"
      sha256 "7ec00e4cbc88c48fc92317b68c90c4cb64ae99ed012af9dc1d678d7ed4841585"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0/celest-0.2.0-linux_arm64.deb"
      sha256 "3f8612c2596762e3c0a3bc660bf5747d29f6526ae1dfd58dcc9942a819a980b6"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0/celest-0.2.0-linux_x64.deb"
      sha256 "d229806c0d7ce4bd94377c87dcc210d324f08f5cd74bca4b759f0cedbfe80667"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-macos_arm64.pkg"
                 else
                   "celest-0.2.0-macos_x64.pkg"
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
