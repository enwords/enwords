module API
  module Mobile
    class BaseController < ::API::BaseController
      protected

      def current_user
        @current_user ||= User.testee
      end
    end
  end
end
