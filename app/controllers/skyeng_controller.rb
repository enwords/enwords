class SkyengController < ApplicationController
  def first_meaning
    response = Api::Skyeng.first_meaning(word: params[:word])

    if response.present?
      render json: response, status: :ok
    else
      render json: response, status: :unprocessable_entity
    end
  end
end
