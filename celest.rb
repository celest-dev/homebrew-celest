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
      if Hardware::CPU.arm?
        system "installer", "-pkg", "celest-latest-macos_arm64.pkg", "-target", "/"
      else
        system "installer", "-pkg", "celest-latest-macos_x64.pkg", "-target", "/"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        system "dpkg", "-i", "celest-latest-linux_arm64.deb"
      else
        system "dpkg", "-i", "celest-latest-linux_x64.deb"
      end
    end
  end

  def caveats
    <<~EOS
      For macOS, the package has been installed using the macOS installer.
      For Linux, the package has been installed using dpkg.
    EOS
  end

  test do
    system "#{bin}/celest", "--version"
  end
end
