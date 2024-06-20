class CelestAT032 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.2/celest-0.3.2-macos_arm64.pkg"
      sha256 "f4fb25f4e8dc4b0a2ac58f7e4e509a19108a8ad2d881821b2c414135709c9e3b"
    else
      url "https://releases.celest.dev/macos_x64/0.3.2/celest-0.3.2-macos_x64.pkg"
      sha256 "dd9151b5cd84f45ba0e88b8d427c2221f508084b4a6fcba71d06f370a7b5e79f"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.2/celest-0.3.2-linux_arm64.deb"
      sha256 "803ab0f57becf05e381e680baf92f033f6b8fc7d240a1b4c1b0d72bcc1e41aea"
    else
      url "https://releases.celest.dev/linux_x64/0.3.2/celest-0.3.2-linux_x64.deb"
      sha256 "2848a1842e65badb926ce39c705ae1c329cf41b3ef0614bca615b59cc6ff765b"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.2-macos_arm64.pkg"
                 else
                   "celest-0.3.2-macos_x64.pkg"
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
