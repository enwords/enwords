module Api
  module Mobile
    class BaseController < ::Api::BaseController
      protected

      def current_user
        @current_user ||= User.first
      end
    end
  end
end
