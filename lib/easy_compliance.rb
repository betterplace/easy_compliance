require_relative 'easy_compliance/version'

module EasyCompliance
  class Error < StandardError; end

  class << self
    attr_accessor :api_key, :api_url, :app_name
  end
end

require_relative 'easy_compliance/client'
require_relative 'easy_compliance/ref'
require_relative 'easy_compliance/result'
