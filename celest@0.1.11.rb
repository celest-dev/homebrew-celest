class CelestAT0111 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.1.11"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.1.11/celest-0.1.11-macos_arm64.pkg"
      sha256 "d5f5d5e4f6f31f4acc5d92022666010bdc4fdea6e84d9593acf7ac07fc38c91c"
    else
      url "https://releases.celest.dev/macos_x64/0.1.11/celest-0.1.11-macos_x64.pkg"
      sha256 "a74ea85a00a97d2e655d2d61519b312795ccfe1192868c2104fbb0eeef845ca3"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.1.11/celest-0.1.11-linux_arm64.deb"
      sha256 "d98c31e7874d3285b6a12753e201d884752b55062b75d1e32e086f2fd1a43aa4"
    else
      url "https://releases.celest.dev/linux_x64/0.1.11/celest-0.1.11-linux_x64.deb"
      sha256 "0749c9c7a6647f2978030f7828c57bdffe79f0413b58c6b3e29a8691216a5758"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.1.11-macos_arm64.pkg"
                 else
                   "celest-0.1.11-macos_x64.pkg"
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
