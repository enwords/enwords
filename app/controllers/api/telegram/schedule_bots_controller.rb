module Api
  module Telegram
    class ScheduleBotsController < ::Api::BaseController
      def message
        return render json: {}, status: :ok unless params[:message]

        ::Telegram::ProcessMessage.run!(params[:message])
        render json: {}, status: :ok
      end
    end
  end
end
