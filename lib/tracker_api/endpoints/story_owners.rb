module TrackerApi
  module Endpoints
    class StoryOwners
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id, params={})
        data = client.paginate("/projects/#{project_id}/stories/#{story_id}/owners", params: params)
        raise Errors::UnexpectedData, 'Array of comments expected' unless data.is_a? Array

        data.map do |owner|
          Resources::Person.new({ story_id: story_id }.merge(owner))
        end
      end

      def delete(project_id, story_id, person_id, params={})
        response = client.delete("/projects/#{project_id}/stories/#{story_id}/owners/#{person_id}", params: params)

        return response.status == 204
      end
    end
  end
end
