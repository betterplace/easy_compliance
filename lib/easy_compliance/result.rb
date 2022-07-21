module EasyCompliance
  # result of an API call
  class Result
    attr_reader :status, :body

    def initialize(status:, body: nil)
      @status = status
      @body = body
    end

    # For methods 1-3. 204 means no hit.
    # returns true if record was found on a sanctions lists, details in body.
    def hit?
      status == 200
    end
  end
end
