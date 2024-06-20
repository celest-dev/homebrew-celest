class CelestAT031 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.1/celest-0.3.1-macos_arm64.pkg"
      sha256 "191048aabc1e81ffc70a142135c13980f7df25dfcf99baf06599abb1cc21c5c0"
    else
      url "https://releases.celest.dev/macos_x64/0.3.1/celest-0.3.1-macos_x64.pkg"
      sha256 "4ae3cd7cc80f2b9da123baf419fbe396459d65c20523e2ca9b7f29a58c920457"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.1/celest-0.3.1-linux_arm64.deb"
      sha256 "b2278d6591906140d7e543a26e54a0ab626d84044b1e3fb5582c568cb1affe54"
    else
      url "https://releases.celest.dev/linux_x64/0.3.1/celest-0.3.1-linux_x64.deb"
      sha256 "c3303cc8e7e3c0ea64d6c36c19a85e1dc2a2b94369d6cf2ec4a47d7a28209b52"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.1-macos_arm64.pkg"
                 else
                   "celest-0.3.1-macos_x64.pkg"
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
