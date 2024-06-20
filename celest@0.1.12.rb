class CelestAT0112 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.12"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.12/celest-0.1.12-macos_arm64.pkg"
      sha256 "c78ff32a3a22ac834d7ae1497f27c786e99fd4c1b6c126ed39636e074f71d9fd"
    else
      url "https://releases.celest.dev/macos_x64/0.1.12/celest-0.1.12-macos_x64.pkg"
      sha256 "b066a30b21ca589e72b4645ea4ef831b9a5e0ce17057277b9c0ece232fb473ff"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.12/celest-0.1.12-linux_arm64.deb"
      sha256 "d0952e0a69e23f2264fd8b607637a1a216179c2a9ca76585a53b90ca9ea3d10d"
    else
      url "https://releases.celest.dev/linux_x64/0.1.12/celest-0.1.12-linux_x64.deb"
      sha256 "93bfa4a56ef4a6f75c7fc071c17daa5b9e38f6dea630d594fa0cdef4ba82a5a5"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.12-macos_arm64.pkg"
                 else
                   "celest-0.1.12-macos_x64.pkg"
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
