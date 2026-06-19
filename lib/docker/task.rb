require 'open3'

module Docker
  module Task
    def self.verbose?
      ENV["VERBOSE"].to_s != "0" && !ENV["VERBOSE"].nil?
    end
    ## Print a message if VERBOSE is set
    def self.put(message)
      puts "[+] #{message}" if verbose?
    end

    ## Task help message
    def self.help
      puts "`rake docker:build:ubuntu[dev|last|prev|legacy]`"
      puts "  Build all pinned Ubuntu images for a Decidim version slot"
      puts "`rake docker:build:ubuntu_one[version,os_name]`"
      puts "  Build one Ubuntu image (e.g. docker:build:ubuntu_one[last,noble])"
      puts "`rake docker:build:redhat_one[version,os_name]`"
      puts "  Build one Red Hat image (e.g. docker:build:redhat_one[last,ubi9])"
      puts "`rake docker:image_ref[distribution,version,os_name]`"
      puts "  Print local image reference (e.g. docker:image_ref[ubuntu,last,noble])"
      puts "  Options:"
      puts "    dev: Build the development version"
      puts "    last: Build the last stable version"
      puts "    prev: Build the previous stable version"
      puts "    legacy: Build the legacy version"
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
      puts "    prev: Push the previous stable version"
      puts "    legacy: Push the legacy version"
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
        output, status = Open3.capture2e(*command)
        unless status.success?
          $stderr.puts "Error running: #{command.join(" ")}"
          $stderr.puts output
          raise "Command failed with exit #{status.exitstatus}: #{command.first}"
        end
      end
    end
  end
end
