module Api
  module Public
    class WordsController < ::Api::BaseController
      def index
        result =
          Word::ByStatus
          .run!(params.merge(user: current_user))
          .paginate(page: params[:page], per_page: 20)

        render json: { collection: result.as_json }, status: :ok
      end

      def current_user
        @current_user ||= User.first
      end
    end
  end
end
