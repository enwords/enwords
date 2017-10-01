class SkyengController < ApplicationController
  def first_meaning
    render json: Api::Skyeng.first_meaning(word: params[:word])
  end
end
