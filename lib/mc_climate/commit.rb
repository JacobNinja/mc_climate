module McClimate

  class Commit

    attr_reader :sha, :blobs

    def initialize(sha, blobs)
      @sha = sha
      @blobs = blobs
    end

  end
end