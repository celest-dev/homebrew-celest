class CelestAT019 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.9"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.9/celest-0.1.9-macos_arm64.pkg"
      sha256 "e8fe9fe5005abc002cc564b43d8c162896e58a4064ec2e8dc2439c6572c2c43f"
    else
      url "https://releases.celest.dev/macos_x64/0.1.9/celest-0.1.9-macos_x64.pkg"
      sha256 "3d845633d99651748b463f4b8fcfc40c0726ced1874e261c342d06fd6ba2bbda"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.9/celest-0.1.9-linux_arm64.deb"
      sha256 "930ac0f71bc919a8d0dfaf0987dec5734b60b5266fbfff5b6a8cd3374744bbec"
    else
      url "https://releases.celest.dev/linux_x64/0.1.9/celest-0.1.9-linux_x64.deb"
      sha256 "8c601ffe3c78db12c86e131f275904fb254341e2c2959159a09bc5ce3782b662"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.9-macos_arm64.pkg"
                 else
                   "celest-0.1.9-macos_x64.pkg"
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
