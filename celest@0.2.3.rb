class CelestAT023 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.3"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.3/celest-0.2.3-macos_arm64.pkg"
      sha256 "dae756fa51036fbd47e73d6187d5c5d89dbd767fb7b496c440230b20dcb5b519"
    else
      url "https://releases.celest.dev/macos_x64/0.2.3/celest-0.2.3-macos_x64.pkg"
      sha256 "e2f39b957b028c9e08716c06fdf995ad6856ed69a068af67e5a6e6e6549e9b83"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.3/celest-0.2.3-linux_arm64.deb"
      sha256 "729466f2f665f5107575d4d1e5b94a622d3b751e0d36dba86068d20534db418d"
    else
      url "https://releases.celest.dev/linux_x64/0.2.3/celest-0.2.3-linux_x64.deb"
      sha256 "1c73962e53c5ca3f69e66562c7332f2b14aa00cd438b229d862dfcf23672b1ff"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.3-macos_arm64.pkg"
                 else
                   "celest-0.2.3-macos_x64.pkg"
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
