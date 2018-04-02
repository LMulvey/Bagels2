module Api::ApiHelper
  
  private

  def handle_response(options)
    if options.nil?
      options = {
        status: :internal_server_error,
        error: [ "Error generating response. Server error." ],
        record: nil
      }
    end
    render(status: options[:status], 
      json: {
        errors: options[:errors], 
        record: options[:record]
      })
  end

  def handle_index(model, params = {})
    params[:limit] = params[:limit].nil? ? 50 : params[:limit]
    params[:page] = params[:page].nil? ? 1 : params[:page]
    all_records = paginate(model.all.order(created_at: :desc), params)
    handle_response(status: :ok, errors: [], record: all_records)
  end

  def handle_show(model)
    record = model.find_by(id: params[:id])
    status = record.nil? ? :not_found : :ok
    handle_response(status: status, errors: [], record: record)
  end

  def index_params
    { limit: params[:limit], page: params[:offset] }
  end

  def paginate(record, params)
    page = params[:page].to_i - 1 # Keep page numbers natural (start at 0, req at 2)
    limit = params[:limit].to_i
    offset = page * limit

    record.limit(limit).offset(offset)
  end
end
