class CelestAT034 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.4"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.4/celest-0.3.4-macos_arm64.pkg"
      sha256 "1a466261efeb395d7fe1d8173d11598746a17183edaccf6930c346e4e3e2e3d6"
    else
      url "https://releases.celest.dev/macos_x64/0.3.4/celest-0.3.4-macos_x64.pkg"
      sha256 "5e7019320a1cb462ada8a7d14bb009cfa7d9d3ce9bf85804317b52977d32d2c7"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.4/celest-0.3.4-linux_arm64.deb"
      sha256 "28a61298189473e7074f6a5ae61f3558283a618d9c7d5dfc430d573bc99aed30"
    else
      url "https://releases.celest.dev/linux_x64/0.3.4/celest-0.3.4-linux_x64.deb"
      sha256 "6c20213203181df848ba0d2be38fd981f5ceb0fd6f36579bf36b5bcfda90b051"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.4-macos_arm64.pkg"
                 else
                   "celest-0.3.4-macos_x64.pkg"
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
