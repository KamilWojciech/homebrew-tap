class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/releases/download/1.1.3/git-msg-prefix-1.1.3.tar.gz"
  version "1.1.3"
  sha256 "23918611f49077bf09b5c81221c178db12de3e0f6fa10856a681ef39bce44228"

  def install
    bin.install "bin/git-msg-prefix"
    lib.install Dir["lib/*"]
    FileUtils.chmod 0555, lib + 'git-hook/prepare-commit-msg'
    homeDir = File.expand_path("~" + ENV['USER'])
    gitHookFile = homeDir + '/.git-templates/hooks/prepare-commit-msg'
    FileUtils.mkdir_p(gitHookFile) unless File.exists?(gitHookFile)

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
