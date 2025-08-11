module Docker
  module Task
    def self.verbose?
      !ENV["VERBOSE"] || ENV["VERBOSE"] == "0"
    end
    ## Print a message if VERBOSE is set
    def self.put(message)
      puts "[+] #{message}" if verbose?
    end

    ## Task help message
    def self.help
      puts "`rake docker:build:ubuntu[dev|last|prev]`"
      puts "  Build the development, last or previous stable version of the Docker image over the last three ubuntu versions"
      puts "  Options:"
      puts "    dev: Build the development version"
      puts "    last: Build the last stable version"
      puts "    prev: Build the previous stable version"
      puts "  Environment variables:"
      puts "    VERBOSE: `1` to print verbose output"
      puts ""

      puts "`rake docker:docs`"
      puts "  Rebuild documentation templates for the current repository"
      puts "  Environment variables:"
      puts "    VERBOSE: `1` to print verbose output"
      puts ""

      puts "`rake docker:push:ubuntu[dev|last|prev]`"
      puts "  Push the development, last or previous stable version to Docker Hub over the last three ubuntu versions,"
      puts "  You must be logged in to Docker Hub before running this task"
      puts "  Options:"
      puts "    dev: Push the development version"
      puts "    last: Push the last stable version"
      puts "    prev: Push the previous stableversion"
      puts "  Environment variables:"
      puts "    DOCKER_HUB_REGISTRY: The Docker Hub registry"
      puts "    DRY_RUN: `1` to not push the image to Docker Hub"
      puts "    VERBOSE: `1` to print verbose output"
      puts ""

      puts "`rake docker:clean`"
      puts "  Clean the Docker clone directory"
      puts "  Environment variables:"
      puts "    VERBOSE: `1` to print verbose output"
      puts ""
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
