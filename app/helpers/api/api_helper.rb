module Api::ApiHelper
  def generate_response(record)
    render(status: response_status(record), 
      json: {
        errors: response_errors(record), 
        record: record
      })
  end

  def handle_index(model)
    all_records = model.all
    render(status: :ok, json: all_records )
  end

  private

  def response_status(record)
    return :not_found if record.nil?
    record.errors.any? ? :unprocessable_entity : :ok
  end

  def response_errors(record)
    return false if record.nil? || record.errors.empty?
    record.errors.full_messages
  end
end
