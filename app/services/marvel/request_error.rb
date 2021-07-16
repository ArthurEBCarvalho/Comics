module Marvel
  class RequestError < StandardError
    attr_reader :status

    def initialize(message, status:)
      @status = status
      super(message)
    end
  end
end