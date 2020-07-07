module API
  class BaseController < ActionController::Base
    before_action -> { params[:format] = 'json' }
  end
end
