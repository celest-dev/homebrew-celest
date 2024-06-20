class CelestAT039 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.9"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.9/celest-0.3.9-macos_arm64.pkg"
      sha256 "46f23aaf744a7453f936170754553d68fb28da65f65d6771e1b27ab536e00470"
    else
      url "https://releases.celest.dev/macos_x64/0.3.9/celest-0.3.9-macos_x64.pkg"
      sha256 "2faac8488d78119725624a1bf8443b95d9947a3a1ecb5ff890bf113baa268725"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.9/celest-0.3.9-linux_arm64.deb"
      sha256 "a7a195e6b4ca23b9bd8458bf17acf9afaad8a3813ff90af4b987987845fad918"
    else
      url "https://releases.celest.dev/linux_x64/0.3.9/celest-0.3.9-linux_x64.deb"
      sha256 "6167abc243c432741b344921926ac96f862538210b65a6897fc9a02dfeb3adc5"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.9-macos_arm64.pkg"
                 else
                   "celest-0.3.9-macos_x64.pkg"
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
