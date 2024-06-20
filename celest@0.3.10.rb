class CelestAT0310 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.10"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.10/celest-0.3.10-macos_arm64.pkg"
      sha256 "c1bf331c3a0e37d8810a55c371d3746de8edab1db9917cbac6eca11af2b4cd13"
    else
      url "https://releases.celest.dev/macos_x64/0.3.10/celest-0.3.10-macos_x64.pkg"
      sha256 "289e83030695923578ee3b7841cdcdd10efe0c3584ee50ab718bd9c9ca6dabce"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.10/celest-0.3.10-linux_arm64.deb"
      sha256 "8ac89093e53dc82daef95dae04acedbdc56cc2e491b3f82b8d8a3a4af5883a27"
    else
      url "https://releases.celest.dev/linux_x64/0.3.10/celest-0.3.10-linux_x64.deb"
      sha256 "92aa8476ba7530e71d4b295b67431cc298280d11cbc9c1a7cbd24a8ea69f031b"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.10-macos_arm64.pkg"
                 else
                   "celest-0.3.10-macos_x64.pkg"
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
