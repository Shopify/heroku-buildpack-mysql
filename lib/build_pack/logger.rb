module BuildPack
  class Logger
    def self.log(message)
      puts "       #{message}"
    end

    def self.log_header(message)
      puts "-----> #{message}"
    end
  end
end
