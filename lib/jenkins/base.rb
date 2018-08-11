# jenkins module
module Jenkins
  # base jenkins class
  class Base
    def self.url
      ENV['JENKINS_URL'].chomp('/')
    end

    def self.retrieve_api_response(path)
      retrieve_request("#{url}#{path}/api/json")
    end

    def self.retrieve_cucumber_json(path)
      retrieve_request("#{url}#{path}/ws/cucumber.json")
    end

    def self.retrieve_request(path)
      JSON.parse(HTTParty.get(path, {
        basic_auth: {
          username: ENV['JENKINS_USERNAME'],
          password: ENV['JENKINS_PASSWORD']
        }
      }).body)
    rescue SocketError
      puts "Jenkins URL in \"ENV['JENKINS_URL']\" not found!"
    rescue JSON::ParserError
      puts "Jenkins path \"#{path}\" not found!"
    end
  end
end
