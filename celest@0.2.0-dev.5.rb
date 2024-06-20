class CelestAT020dev5 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0-dev.5"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0-dev.5/celest-0.2.0-dev.5-macos_arm64.pkg"
      sha256 "daeddafbecee2badcff404d59aac4d9545849a6a994059ccd8cd032dac4c8a77"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0-dev.5/celest-0.2.0-dev.5-macos_x64.pkg"
      sha256 "1c98273e78ac68bab82a18bfa7dc7340325d6c8bb89478a06ad6081897e8d23c"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0-dev.5/celest-0.2.0-dev.5-linux_arm64.deb"
      sha256 "c885bf76a91c32fef81d62566aa7b36653d7e6d2660832b79f365c273cea8f75"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0-dev.5/celest-0.2.0-dev.5-linux_x64.deb"
      sha256 "5b15d3e4a0b95f591d6af7f9bec5d4d1be4409691a8f3e76c27ff50fceeae3ff"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-dev.5-macos_arm64.pkg"
                 else
                   "celest-0.2.0-dev.5-macos_x64.pkg"
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
