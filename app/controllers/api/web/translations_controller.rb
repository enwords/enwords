class API::Web::TranslationsController < ::API::BaseController
  def index
    result = Word::Translate.run!(text: params[:word], from: params[:from], to: params[:to])
    if result.present?
      render json: result, status: :ok
    else
      render json: result, status: :unprocessable_entity
    end
  end
end
