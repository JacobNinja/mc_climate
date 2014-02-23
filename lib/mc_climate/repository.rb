module McClimate

  class Repository

    def initialize(path)
      @path = path
    end

    def last_commit
      sha = git('show --pretty="%H"').lines.first.chomp("\n")
      commit(sha)
    end

    def commit(sha)
      files = git("ls-tree --name-only -r #{sha}").split("\n")
      blobs = files.map {|file| Blob.new(file, git("show #{sha}:#{file}")) }
      Commit.new(sha, blobs)
    end

    private

    def git(command)
      git_path = File.join(@path, '.git')
      raise "Git repository not found at: #{git_path}" unless File.exists?(git_path)
      `git --git-dir=#{git_path} #{command}`
    end

  end

end