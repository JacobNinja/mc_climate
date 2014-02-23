module McClimate

  class Blob

    attr_reader :file, :contents

    def initialize(file, contents)
      @file = file
      @contents = contents
    end

  end

end