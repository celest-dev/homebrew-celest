class CelestAT0110 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.10"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.10/celest-0.1.10-macos_arm64.pkg"
      sha256 "fb0d61de99c63cb34d914df36f84bfb6c0b4007e6ce51b9851aef7986a45a288"
    else
      url "https://releases.celest.dev/macos_x64/0.1.10/celest-0.1.10-macos_x64.pkg"
      sha256 "984b291c22dda7e62b38810f1f46de234d2a6aa4042aee9de2cdc65f54553f3d"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.10/celest-0.1.10-linux_arm64.deb"
      sha256 "da10563dbcc74ae2842458132c6be3d9a4e11906462a4605c8c1d4293cb80efd"
    else
      url "https://releases.celest.dev/linux_x64/0.1.10/celest-0.1.10-linux_x64.deb"
      sha256 "d55860ed191f857652ed29c76f6afc096d5d28b085ee92d245466d7bba168d25"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.10-macos_arm64.pkg"
                 else
                   "celest-0.1.10-macos_x64.pkg"
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
