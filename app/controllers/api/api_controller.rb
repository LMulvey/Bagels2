module Api
  class ApiController < ApplicationController
    include ApiHelper

    private

    def index_params
      { limit: params[:limit], offset: params[:offset] }
    end
  end
end