module Api
  module Telegram
    class ScheduleBotsController < ActionController::Base
      def message
        return render json: {}, status: :ok unless params[:message]

        text = ::Telegram::ScheduleBot::GetAnswer.run!(params[:message])

        ::Telegram::ScheduleBot::Reply.run!(
          chat_id: params.dig(:message, :chat, :id), text: text
        )
        render json: {}, status: :ok
      end
    end
  end
end
