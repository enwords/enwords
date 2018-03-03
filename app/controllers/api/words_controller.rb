module Api
  class WordsController < ActionController::Base
    before_action :default_format_json

    def generate_phrase
      render json: { resource: Word::GeneratePhrase.run! }, status: :ok
    end

    private

    def default_format_json
      request.format = 'json' if params[:format].blank?
    end
  end
end
