require 'excon'

module EasyCompliance
  # client for https://easycompliance.de/schnittstellen/api/
  module Client
    class Error < EasyCompliance::Error; end

    module_function

    METHODS = {
      check_now:  1, # status 204 = no matches; 200 = json of matches
      submit:     2, # same as 1, also added to list for future checks
      fetch_list: 3, # get json of matches in last 24h (204 = none)
    }
    HEADERS = {
      'Content-Type': 'application/x-www-form-urlencoded',
    }

    # @return [ Array ] response body and status
    def submit(record:, value:)
      ref = EasyCompliance::Ref.for_record(record)
      post(method: :submit, ref: ref, name: value)
    end

    # @return [ Array ] response body and status
    def fetch_list
      post(method: :fetch_list)
    end

    # @return [ Array ] response body and status
    def post(method:, **body)
      body[:method] = METHODS[method] or raise Error, "unknown method #{method}"
      body[:api_key] = EasyCompliance.api_key or raise Error, "must set api_key"
      url = EasyCompliance.api_url or raise Error, "must set api_url"

      res = Excon.post(url, body: URI.encode_www_form(body), headers: HEADERS)
      res.status < 300 or raise Error, "#{res.status}: #{res.body}"

      [res.body, res.status]
    rescue Excon::Error => e
      raise Error, "Network error: #{e.class.name} - #{e.message}"
    end
  end
end
