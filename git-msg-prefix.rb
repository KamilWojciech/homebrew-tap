class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/releases/download/1.2.4/git-msg-prefix-1.2.4.tar.gz"
  version "1.2.4"
  sha256 "4aad05a3fe54b8abff5262e9b93062d48a00d12230533b6a7bafa60739a37192"

  def install
    bin.install "bin/git-msg-prefix"
    lib.install Dir["lib/*"]
    FileUtils.chmod 0555, lib + 'git-hook/prepare-commit-msg'
    homeDir = File.expand_path("~" + ENV['USER'])
    gitHookDir = homeDir + '/.git-templates/hooks/'
    gitHookFile = gitHookDir + 'prepare-commit-msg'
    FileUtils.mkdir_p(gitHookDir) unless File.exists?(gitHookDir)

    libLinkFile = "/usr/local/lib/prepare-commit-msg"

    linked = false
    if File.symlink?(gitHookFile)
      symlinkTarget = File.readlink(gitHookFile)
      if File.fnmatch libLinkFile, symlinkTarget
        linked = true
      end
    end

    lib.install_symlink lib + 'git-hook/prepare-commit-msg'

    if File.exist?(gitHookFile) && !linked
      print "File '" + gitHookFile + "' already exists! Do you want to replace it? [Y/n]: "
      input = STDIN.gets.strip
      if input.downcase != 'y'
        return false
      else
        File.delete gitHookFile
      end
    end

    if !linked
      FileUtils.ln_s libLinkFile, gitHookFile
    end
  end
end
