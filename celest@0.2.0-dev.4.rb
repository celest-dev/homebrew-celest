class CelestAT020dev4 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0-dev.4"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0-dev.4/celest-0.2.0-dev.4-macos_arm64.pkg"
      sha256 "090212ad76dfd8c7982df19bce9eab3e2434773f14b3f2183481d4ea009cb700"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0-dev.4/celest-0.2.0-dev.4-macos_x64.pkg"
      sha256 "6bdbf194fb6fb30275ff244052b54e21f1b6c74b135546600a27b87ed505923c"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0-dev.4/celest-0.2.0-dev.4-linux_arm64.deb"
      sha256 "d4b03a0488fd92f261153f7c526e2c4e05329f03778e98b79950aad7f90361fa"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0-dev.4/celest-0.2.0-dev.4-linux_x64.deb"
      sha256 "c939d53bf24c5e2378fb3ef37edcc431bf3f6144467ade8fcc00d23e6ad960d2"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-dev.4-macos_arm64.pkg"
                 else
                   "celest-0.2.0-dev.4-macos_x64.pkg"
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
