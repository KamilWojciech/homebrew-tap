class GitMsgPrefix < Formula
  desc ""
  homepage "https://github.com/KamilWojciech/git-msg-prefix"
  url "https://github.com/KamilWojciech/git-msg-prefix/archive/1.0.2.tar.gz"
  version "1.0.2"
  sha256 "67bfbda90b7c707da639baf19676a6e3007c92fa77d0cc8c7fba8d86c8a35767"

  def install
    bin.install "bin/git-msg-prefix"
    lib.install Dir["lib/*"]
    FileUtils.chmod 0555, lib + 'git-hook/prepare-commit-msg'
    homeDir = File.expand_path("~" + ENV['USER'])
    gitHookFile = homeDir + '/.git-templates/hooks/prepare-commit-msg'
    if File.exist?(gitHookFile)
      print "File '" + gitHookFile + "' already exists! Do you want to replace it? [Y/n]: "
      input = STDIN.gets.strip
      if input.downcase == 'y'
        File.delete gitHookFile
        FileUtils.ln_s lib + 'git-hook/prepare-commit-msg', gitHookFile
      end
    end
  end
end
