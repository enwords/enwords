module Api
  module Mobile
    class WordsController < ::Api::BaseController
      def index
        result =
          Word::ByStatus
          .run!(user: current_user, status: params[:status])
          .paginate(page: params[:page] || 1, per_page: 20)

        render json: { collection: result.as_json }, status: :ok
      end

      def current_user
        @current_user ||= User.first
      end
    end
  end
end
