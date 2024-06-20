class CelestAT0311 < Formula
  desc "The flutter cloud platform"
  homepage "https://celest.dev"
  version "0.3.11"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/macos_arm64/0.3.11/celest-0.3.11-macos_arm64.pkg"
      sha256 "2194461c623d4338ecf8f560d4de9b63b8086b159220943aa9f8e171f404b973"
    else
      url "https://releases.celest.dev/macos_x64/0.3.11/celest-0.3.11-macos_x64.pkg"
      sha256 "d8f1c6cd2d317084094de5ae2eef3d3c7ab1ce2324a6cf86b045147b43d7a4ba"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.celest.dev/linux_arm64/0.3.11/celest-0.3.11-linux_arm64.deb"
      sha256 "839dae472ab2004870d46de0f6179a6af12860e531e8f663d4ad0065473ea557"
    else
      url "https://releases.celest.dev/linux_x64/0.3.11/celest-0.3.11-linux_x64.deb"
      sha256 "d8cab10840b1fc7d046161da6aa227ba9098a298b1eec357ead85341b3ea7ef5"
    end
  end

  license "MIT"

  def install
    if OS.mac?
      pkg_file = if Hardware::CPU.arm?
                   "celest-0.3.11-macos_arm64.pkg"
                 else
                   "celest-0.3.11-macos_x64.pkg"
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
