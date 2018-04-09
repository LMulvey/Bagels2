# Base class for API Services
class ApiBaseService
  def initialize(params)
    @params = params
  end

  def self.call(params)
    new(params).call
  end
end
