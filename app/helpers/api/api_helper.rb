module Api::ApiHelper
  def generate_response(record)
    render(status: response_status(record), 
      json: {
        errors: response_errors(record), 
        result: record
      })
  end

  def handle_index(model, incoming_params = {})
    params = { 
      limit: 50,
      page: 1
    }.merge(incoming_params)
    all_records = paginate(model.all.order(created_at: :desc), params)
    render(status: :ok, json: all_records )
  end

  private

  def response_status(record)
    return :not_found if record.nil?
    record.errors.any? || !record ? :unprocessable_entity : :ok
  end

  def response_errors(record)
    return [] if record.nil? || record.errors.empty?
    return [ "Error performing task. Contact administrator" ] if !record
    record.errors.full_messages
  end

  def paginate(record, params)
    page = params[:page].to_i - 1 # Keep page numbers natural (start at 0, req at 2)
    limit = params[:limit].to_i
    offset = page * limit

    record.limit(limit).offset(offset)
  end
end
