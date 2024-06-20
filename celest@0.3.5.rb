class CelestAT035 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.5"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.5/celest-0.3.5-macos_arm64.pkg"
      sha256 "81c7c1713d9a4cfc1fd2b5d4226b4bbdf3490f0a22101739d8140b87c52033c6"
    else
      url "https://releases.celest.dev/macos_x64/0.3.5/celest-0.3.5-macos_x64.pkg"
      sha256 "7a83419b6f6d90e7b31695f7275609e5209cc1b08833eac7d252f37b31ba57a6"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.5/celest-0.3.5-linux_arm64.deb"
      sha256 "0a519ef48bac5f7ad87cf3fbf0c00ae4fcfaa8e0d255e641c5182f8cace4d878"
    else
      url "https://releases.celest.dev/linux_x64/0.3.5/celest-0.3.5-linux_x64.deb"
      sha256 "93657467e8ee1db8a6516b39557bc788f9c348c464a8aa6ebce9acf380ab421f"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.5-macos_arm64.pkg"
                 else
                   "celest-0.3.5-macos_x64.pkg"
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
