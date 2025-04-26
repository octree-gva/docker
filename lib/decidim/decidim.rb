module Decidim
  class Decidim
    include Singleton
    
    def on_cloned_repository(branch = nil, &block)
      clone_repository unless File.exist?(clone_destination)
      Dir.chdir(clone_destination) do 
        Docker::Task.system!("git", "checkout", branch, silent: true)  if branch
        block.call
      end
    end

    def versions
      @versions ||= [DecidimVersion.new(self, "develop")] + stable_branches
    end

    def clean_clone
      FileUtils.rm_rf(clone_destination) if File.exist?(clone_destination)
    end

    private

    def clone_destination
      @clone_destination ||= "decidim-clone"
    end

    def clone_repository
      @clone_repository ||= Docker::Task.system!(
        "git", 
        "clone", 
        "--branch", "develop", 
        "--no-single-branch", "https://github.com/decidim/decidim.git", 
        clone_destination
      )
    end

    def stable_branches
      on_cloned_repository do
        branches = %x(git branch -r | grep "origin/release/.*-stable")
        branches.split("\n").map do |branch|
          DecidimVersion.new(self, branch.strip.gsub('origin/', ''))
        end
      end.sort_by(&:updated_at).reverse
    end
  end
end