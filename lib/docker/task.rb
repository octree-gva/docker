module Docker
  module Task
    def self.verbose?
      ENV["VERBOSE"] && ENV["VERBOSE"] == "1"
    end
    ## Print a message if VERBOSE is set
    def self.put(message)
      puts "[+] #{message}" if verbose?
    end

    ## Task help message
    def self.help
      puts "Usage: rake docker:build[dev|last|prev]"
    end

    ## Run a system call
    # @see https://ruby-doc.org/3.4.1/Kernel.html#method-i-system
    def self.system!(*command, silent: false)
      if verbose? && !silent
        puts " => [system] # #{command.join(" ")}"
        system(*command, exception: true)
      else
        system(*command, err: File::NULL, out: File::NULL, exception: true)
      end
    end
  end
end