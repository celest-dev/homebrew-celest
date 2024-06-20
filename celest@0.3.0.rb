class CelestAT030 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.0/celest-0.3.0-macos_arm64.pkg"
      sha256 "f6e501b1bbbc6a60555a054113bd772be30556821cacae8b26c6ecd215e1af9d"
    else
      url "https://releases.celest.dev/macos_x64/0.3.0/celest-0.3.0-macos_x64.pkg"
      sha256 "8e685ac9be798591b27c08e19f0b5cf45e959b6048f42c7941a1e188d4a41510"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.0/celest-0.3.0-linux_arm64.deb"
      sha256 "5d011749b8bc9c7958200c2698f041ef9163c65a4cebb8248f3c0140a36b562e"
    else
      url "https://releases.celest.dev/linux_x64/0.3.0/celest-0.3.0-linux_x64.deb"
      sha256 "5323c06caf557abfd2eb1591623cf53560d9d48c79888635c78b7d56fd06f2c8"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.0-macos_arm64.pkg"
                 else
                   "celest-0.3.0-macos_x64.pkg"
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
