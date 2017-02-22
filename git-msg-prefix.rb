class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/releases/download/1.2.2/git-msg-prefix-1.2.2.tar.gz"
  version "1.2.2"
  sha256 "c4c0dfc504a451fe726b98a3afaca975a910b79652a122636400835d959d4b69"

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

    File.delete gitHookFile unless !File.exists?(gitHookFile)
    lib.install_symlink lib + 'git-hook/prepare-commit-msg'
    FileUtils.ln_s '/usr/local/lib/prepare-commit-msg', gitHookFile
  end
end
