# jenkins module
module Jenkins
  autoload :Base, 'jenkins/base'

  # A class represents jenkins job
  class View
    def initialize(name, build_number = nil)
      @raw_api_response = nil

      @name = name
      @build_number = build_number
    end

    # RESPONSE GETTER
    def description
      init_raw_api_response
      @raw_api_response['description']
    end

    def jobs
      init_raw_api_response
      @raw_api_response['jobs']
    end

    private

    def init_raw_api_response
      @raw_api_response ||= Base.retrieve_api_response("/view/#{@name}")
    end
  end
end
