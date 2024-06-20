class CelestAT040dev2 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.4.0-dev.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.4.0-dev.2/celest-0.4.0-dev.2-macos_arm64.pkg"
      sha256 "ffdb812f8e46aa0ea92cebdccc53809856251d0b6a087600b7466b6560a9fba3"
    else
      url "https://releases.celest.dev/macos_x64/0.4.0-dev.2/celest-0.4.0-dev.2-macos_x64.pkg"
      sha256 "8a17e181ad363a7091a0fada45477206db3dbf9c6c0325d979063acac918b24d"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.4.0-dev.2/celest-0.4.0-dev.2-linux_arm64.deb"
      sha256 "f5b852874f527cad9f6525cee37d2460df8ce1cd0a4471e4c8bd924689880f2e"
    else
      url "https://releases.celest.dev/linux_x64/0.4.0-dev.2/celest-0.4.0-dev.2-linux_x64.deb"
      sha256 "e692ae866f884a3c8c34e628691d8c57c143a59951bd8edc88c537b31eaefa36"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.4.0-dev.2-macos_arm64.pkg"
                 else
                   "celest-0.4.0-dev.2-macos_x64.pkg"
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
