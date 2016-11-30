class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/archive/1.0.4.tar.gz"
  version "1.0.4"
  sha256 "4cf770b0490922a4e00b5159c02778715236285d7a08d6fc9e3e0feb7997ae82"

  def install
    bin.install "bin/git-msg-prefix"
    lib.install Dir["lib/*"]
    FileUtils.chmod 0555, lib + 'git-hook/prepare-commit-msg'
    homeDir = File.expand_path("~" + ENV['USER'])
    gitHookFile = homeDir + '/.git-templates/hooks/prepare-commit-msg'

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
