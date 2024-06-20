class CelestAT042 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.4.2"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.4.2/celest-0.4.2-macos_arm64.pkg"
      sha256 "f9bef3e19731ed079a075165978f519a397a7e6de6a4f70bd61d5e403dc275a7"
    else
      url "https://releases.celest.dev/macos_x64/0.4.2/celest-0.4.2-macos_x64.pkg"
      sha256 "2cbf5b100aa7d6a235b922cf095c2ff805136af80e024a289d07448780d7ef66"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.4.2/celest-0.4.2-linux_arm64.deb"
      sha256 "0dfae636490aa6df5560a41cc34082c3d5417b042411750d2758bcc99a170f83"
    else
      url "https://releases.celest.dev/linux_x64/0.4.2/celest-0.4.2-linux_x64.deb"
      sha256 "02c6d7008d37749cf936b630f68b5562b87a905c52550c24f9657bef41b4caea"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.4.2-macos_arm64.pkg"
                 else
                   "celest-0.4.2-macos_x64.pkg"
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
