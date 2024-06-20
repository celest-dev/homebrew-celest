class CelestAT043 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.4.3"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.4.3/celest-0.4.3-macos_arm64.pkg"
      sha256 "3c67bf4540beca90cf83e2cb90b988b44ebc5e476f63c7d6e47330464aad547e"
    else
      url "https://releases.celest.dev/macos_x64/0.4.3/celest-0.4.3-macos_x64.pkg"
      sha256 "27a4ea6e7d522f36c6f03d16362bc45a24c3dc109f68242fe7cc9105caaf67ea"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.4.3/celest-0.4.3-linux_arm64.deb"
      sha256 "73ea6dc0cf947224e8aaf825565ecb79c65a79e0d54afe140bcc634b951838c8"
    else
      url "https://releases.celest.dev/linux_x64/0.4.3/celest-0.4.3-linux_x64.deb"
      sha256 "a283c822397bd6f2c77068eb6ecdb07d0d43bc46d7a0676da83aafe106c18c1e"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.4.3-macos_arm64.pkg"
                 else
                   "celest-0.4.3-macos_x64.pkg"
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
