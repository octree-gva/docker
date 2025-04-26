# frozen_string_literal: true

module Docker
  class Ubuntu
    include Singleton

    def latest
      @latest ||= tags do |tag|
        next unless tag.name.match?(/^\d+\.\d+$/)
        tag.name
      end.first
    end
    

    private
    def repository_api
      @repository_api ||= Docker::DockerHub.instance.repositories
    end

    def tags(&block)
      result = repository_api.v2_namespaces_namespace_repositories_repository_tags_get_with_http_info(
        "library",
        "ubuntu",
        {page: 1, page_size: 100}
      )
      result.map do |paginated_tags|
        next unless paginated_tags.respond_to?(:results)
        paginated_tags.results.map do |tag|
          block.call(tag)
        end.compact
      end.flatten
    end
  end
end
