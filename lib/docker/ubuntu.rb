# frozen_string_literal: true

module Docker
  class Ubuntu
    include Singleton
    include Docker::Concern::DockerHubImage
    def name
      "ubuntu"
    end
    
    def repository
      "library/ubuntu"
    end
  end
end
