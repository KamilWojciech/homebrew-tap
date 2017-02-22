class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/releases/download/1.2.3/git-msg-prefix-1.2.3.tar.gz"
  version "1.2.3"
  sha256 "a89e82814c76906f98f82592adfb203feac05bf3817a74150cbc9b14e983ec5d"

  def install
    bin.install "bin/git-msg-prefix"
    lib.install Dir["lib/*"]
    FileUtils.chmod 0555, lib + 'git-hook/prepare-commit-msg'
    homeDir = File.expand_path("~" + ENV['USER'])
    gitHookDir = homeDir + '/.git-templates/hooks/'
    gitHookFile = gitHookDir + 'prepare-commit-msg'
    FileUtils.mkdir_p(gitHookDir) unless File.exists?(gitHookDir)

    linked = false
    if File.symlink?(gitHookFile)
      symlinkTarget = File.readlink(gitHookFile)
      if File.fnmatch File.expand_path(prefix + '../') + '**prepare-commit-msg', symlinkTarget
        linked = true
      end
    end

    if File.exist?(gitHookFile) && !linked
      print "File '" + gitHookFile + "' already exists! Do you want to replace it? [Y/n]: "
      input = STDIN.gets.strip
      if input.downcase != 'y'
        return false
      end
    end

    libLinkFile = "/usr/local/lib/prepare-commit-msg"
    File.delete gitHookFile unless !File.exists?(gitHookFile)
    lib.install_symlink lib + 'git-hook/prepare-commit-msg'
    File.delete libLinkFile unless !File.exists?(libLinkFile)
    FileUtils.ln_s libLinkFile, gitHookFile
  end
end
