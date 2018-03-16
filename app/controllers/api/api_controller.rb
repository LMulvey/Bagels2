module Api
  class ApiController < ApplicationController
    def generate_response(record)
      render(json: {
        status: record.errors.any? ? 422 : 201,
        errors: record.errors.full_messages, 
        record: record
      })
    end

    def handle_index(model)
      render(json: model.all)
    end
  end
end