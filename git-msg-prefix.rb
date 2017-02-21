class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/releases/download/1.1.4/git-msg-prefix-1.1.4.tar.gz"
  version "1.1.4"
  sha256 "c603fd97713decd3c5948f5ae573a94d409c2318e71037486796737f6604c590"

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

    File.delete gitHookFile
    FileUtils.ln_s lib + 'git-hook/prepare-commit-msg', gitHookFile
  end
end
