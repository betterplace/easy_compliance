require 'excon'
require 'openssl'

module EasyCompliance
  # client for https://easycompliance.de/schnittstellen/api/
  module Client
    class Error < EasyCompliance::Error; end

    module_function

    # check if record is currently on a sanctions list
    # @return [ EasyCompliance::Result ]
    def check_now(record:, value:)
      ref = EasyCompliance::Ref.for_record(record)
      post(method: 1, ref: ref, name: value)
    end

    # like `#check_now`, but also adds to list for future automatic checks
    # @return [ EasyCompliance::Result ]
    def submit(record:, value:)
      ref = EasyCompliance::Ref.for_record(record)
      post(method: 2, ref: ref, name: value)
    end

    # get matches of last 24 hours
    # @return [ EasyCompliance::Result ]
    def fetch_list
      post(method: 3)
    end

    HEADERS = {
      'Content-Type': 'application/x-www-form-urlencoded'
    }

    # @return [ EasyCompliance::Result ]
    def post(**body)
      body[:api_key] = EasyCompliance.api_key or raise Error, 'must set api_key'
      res = Excon.post(
        api_url,
        body: URI.encode_www_form(body),
        headers: HEADERS,
        idempotent: true,
        retry_limit: retry_limit,
        retry_interval: retry_interval
      )
      res.status < 300 or raise Error, "#{res.status}: #{res.body}"

      EasyCompliance::Result.new(status: res.status, body: res.body)
    rescue Excon::Error, OpenSSL::OpenSSLError => e
      raise Error, "Network error: #{e.class.name} - #{e.message}"
    end

    def retry_limit
      EasyCompliance.retry_limit || 3
    end

    def retry_interval
      EasyCompliance.retry_interval || 5
    end

    def api_url
      EasyCompliance.api_url || raise(Error, 'must set api_url')
    end
  end
end
