class Celest < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/latest/celest-latest-macos_arm64.pkg"
      sha256 "e70b351443e782d8ecc49e7a36eb6efee3ee5a4557e6040f956ae2625e222427"
    else
      url "https://releases.celest.dev/macos_x64/latest/celest-latest-macos_x64.pkg"
      sha256 "725af8d398f18d50f913805907fa2d4b7a8c81f8697f28da7a8f7c2d115f2594"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/latest/celest-latest-linux_arm64.deb"
      sha256 "eb459565228cf82552a06a58ba69371261db233ae48c576ae7d430c7da12c7d6"
    else
      url "https://releases.celest.dev/linux_x64/latest/celest-latest-linux_x64.deb"
      sha256 "e9b5b80d493ab61424ffcb6427092ecc7d2e09ed95548900bf53ccd4471ba899"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-latest-macos_arm64.pkg"
                 else
                   "celest-latest-macos_x64.pkg"
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
