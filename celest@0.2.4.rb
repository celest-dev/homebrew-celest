class CelestAT024 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.4"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.4/celest-0.2.4-macos_arm64.pkg"
      sha256 "56c82b29172f24b385cb077df4227d05a4a63836651bd4606777351b10e45608"
    else
      url "https://releases.celest.dev/macos_x64/0.2.4/celest-0.2.4-macos_x64.pkg"
      sha256 "3492dbfe4b35f43f61b09307b3c7d6166d46be625bb3ae3a72246d17f282706b"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.4/celest-0.2.4-linux_arm64.deb"
      sha256 "d21ef79e706d44210f19f3d84009a98eedce8477f7fd92c289fc992bee8808b3"
    else
      url "https://releases.celest.dev/linux_x64/0.2.4/celest-0.2.4-linux_x64.deb"
      sha256 "05dab601cc7dd7144f252af86a2a1c4273159f7f46e1c4e7150b8366b7671ca6"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.4-macos_arm64.pkg"
                 else
                   "celest-0.2.4-macos_x64.pkg"
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
