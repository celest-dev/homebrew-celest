class CelestAT038 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.8"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.8/celest-0.3.8-macos_arm64.pkg"
      sha256 "b5960c8afedf7ebbd0cf050e3851331acd103e6debc99a4d11273d48211fe9df"
    else
      url "https://releases.celest.dev/macos_x64/0.3.8/celest-0.3.8-macos_x64.pkg"
      sha256 "44070ce82a477ff20b442b5e538015a5e9c1f0f5995ed7f85d8767ff15d398f0"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.8/celest-0.3.8-linux_arm64.deb"
      sha256 "2c7d4025649ac45238c88b393eba1656ff272e827cd38a2fb25fd3d7b3b994d2"
    else
      url "https://releases.celest.dev/linux_x64/0.3.8/celest-0.3.8-linux_x64.deb"
      sha256 "8fa9bf4fbbacaf805907c81f3667b1c62d75b0a07b2e72d410450aa3de778de0"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.8-macos_arm64.pkg"
                 else
                   "celest-0.3.8-macos_x64.pkg"
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
