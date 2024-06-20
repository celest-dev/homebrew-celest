class CelestAT033 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.3"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.3/celest-0.3.3-macos_arm64.pkg"
      sha256 "bc09af92315928da51e1b539c363c30aaa24a2c01eb0713293bc3b1ab0d57daf"
    else
      url "https://releases.celest.dev/macos_x64/0.3.3/celest-0.3.3-macos_x64.pkg"
      sha256 "25dd2eb465f5e67abc01dfdc87064aa375e57af3d1fcc87187217f2ba1dd0032"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.3/celest-0.3.3-linux_arm64.deb"
      sha256 "7d32b2002dfc0cc050190c2b17c3200030c81b1067a7ebf78c1e2ee525cf21ba"
    else
      url "https://releases.celest.dev/linux_x64/0.3.3/celest-0.3.3-linux_x64.deb"
      sha256 "269f84ba3dce439f2562964b70f4ba8017aedd78ff7e321ab90f621a7cd2f29a"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.3-macos_arm64.pkg"
                 else
                   "celest-0.3.3-macos_x64.pkg"
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
