# jenkins module
module Jenkins
  autoload :Base, 'jenkins/base'
  autoload :Job,  'jenkins/job'

  # A class represents jenkins multijob
  class MultiJob < Job
    def last_build_sub_builds
      init_raw_api_response
      last_build['subBuilds']
    end

    def has_failure?
      last_build_sub_builds.map { |build| build['result'] }.any? { |status| status != 'SUCCESS' }
    end
  end
end
