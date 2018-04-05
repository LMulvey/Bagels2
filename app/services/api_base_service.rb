class ApiBaseService
  def initialize(params)
    @params = params
  end

  def self.call(params)
    new(params).call
  end

  private

  def response(status, errors, record)
    { status: status, errors: errors, record: record }
  end
end
