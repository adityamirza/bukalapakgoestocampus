# jenkins module
module Jenkins
  autoload :Base, 'jenkins/base'

  # A class represents jenkins job
  class Job
    attr_reader :raw_api_response

    def initialize(name, build_number = nil)
      @raw_api_response = nil

      @name = name
      @build_number = build_number
    end

    # RESPONSE MANIPULATOR
    def title
      desc = description.scan(/(?:title|judul|Title|Judul): ([\w -:()]*)/)
      desc.empty? ? name : desc.first.first
    end

    # RESPONSE GETTER
    def description
      init_raw_api_response
      @raw_api_response['description']
    end

    def downstream_projects
      init_raw_api_response
      @raw_api_response['downstreamProjects']
    end

    def last_build
      init_raw_api_response
      @raw_api_response['lastBuild']
    end

    def name
      init_raw_api_response
      @raw_api_response['name']
    end

    def url
      init_raw_api_response
      @raw_api_response['url']
    end

    private

    def init_raw_api_response
      @raw_api_response ||= Base.retrieve_api_response("/job/#{@name}")
    end
  end
end
