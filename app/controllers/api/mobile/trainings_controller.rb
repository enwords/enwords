module Api
  module Mobile
    class TrainingsController < BaseController
      def create
        result =
          Training::Create.run!(
            word_ids: params[:word_ids],
            training_type: params[:training_type],
            user: current_user
          )

        render json: { resource: result.as_json }, status: :ok
      end
    end
  end
end
