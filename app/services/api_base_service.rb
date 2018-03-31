class ApiBaseService
  def initialize(params = {})
    @params = {
      # Set any explicit defaults here
    }.merge(params)
  end

  def self.call(params = {})
    new(params).call
  end
end