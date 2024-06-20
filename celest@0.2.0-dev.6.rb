class CelestAT020dev6 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.2.0-dev.6"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.2.0-dev.6/celest-0.2.0-dev.6-macos_arm64.pkg"
      sha256 "8808f40394e2461f5e6182c1767706486334abe31a522d728703d1d0f7702a6b"
    else
      url "https://releases.celest.dev/macos_x64/0.2.0-dev.6/celest-0.2.0-dev.6-macos_x64.pkg"
      sha256 "b48c1a9d0b68284a42092aa45242364046bd669897501b4c0b7f96d38fc29346"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.2.0-dev.6/celest-0.2.0-dev.6-linux_arm64.deb"
      sha256 "284170ccb89a9cc6c0e04e976749fa6915c846cdf29bbd0c8f6bbf1a718b4927"
    else
      url "https://releases.celest.dev/linux_x64/0.2.0-dev.6/celest-0.2.0-dev.6-linux_x64.deb"
      sha256 "f855e6de4e5faea06d00218fdfd1b71bbafc7a0eca9bbf0f33097a8fd965203e"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.2.0-dev.6-macos_arm64.pkg"
                 else
                   "celest-0.2.0-dev.6-macos_x64.pkg"
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
