class CelestAT018 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.8"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.8/celest-0.1.8-macos_arm64.pkg"
      sha256 "00bbd89b868e13a083c3cd257f3cfcecdd5c54c629818d428d878cb7e6513a19"
    else
      url "https://releases.celest.dev/macos_x64/0.1.8/celest-0.1.8-macos_x64.pkg"
      sha256 "861ec443871cc04a2a901bf48185983d3c3af54842b8d2133b163de8d1c63325"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.8/celest-0.1.8-linux_arm64.deb"
      sha256 "80195f7d9cd72234168c148db5a19d1c4174956150746291c4175ee4fb4c4b8f"
    else
      url "https://releases.celest.dev/linux_x64/0.1.8/celest-0.1.8-linux_x64.deb"
      sha256 "fcee28ec84accac1ac0849557f4fb63bc9850d7d82e13499f8d37ac3ae4122b3"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.8-macos_arm64.pkg"
                 else
                   "celest-0.1.8-macos_x64.pkg"
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
