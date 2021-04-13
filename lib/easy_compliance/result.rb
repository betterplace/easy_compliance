module EasyCompliance
  # result of an API call
  class Result
    attr_reader :status, :body

    def initialize(status:, body: nil)
      @status = status
      @body = body
    end

    # For methods 1-3. 204 means no hit.
    def hit?
      status == 200
    end
  end
end
