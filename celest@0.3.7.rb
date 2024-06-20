class CelestAT037 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.7"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.7/celest-0.3.7-macos_arm64.pkg"
      sha256 "faad69429c4e0cd606c15d05124b0e6dddd92e57bf411b3cf3eba70aaa3a44e4"
    else
      url "https://releases.celest.dev/macos_x64/0.3.7/celest-0.3.7-macos_x64.pkg"
      sha256 "cfcf455fddcbc1bae6b229ddcc50196eba3c3c381677623e86870352031c908c"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.7/celest-0.3.7-linux_arm64.deb"
      sha256 "ab1ef0161ebac18ec6ba4140303ae95c933bb8637799767a577e9c6d8995c380"
    else
      url "https://releases.celest.dev/linux_x64/0.3.7/celest-0.3.7-linux_x64.deb"
      sha256 "bbb2caa9a02642854aa392fa29445e37ed22d28d6ff0fe4742b9dd94429f2b56"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.7-macos_arm64.pkg"
                 else
                   "celest-0.3.7-macos_x64.pkg"
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
