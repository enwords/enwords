module Api
  module Telegram
    class ScheduleBotsController < ::Api::BaseController
      def message
        return render json: {}, status: :ok unless params[:message]

        text = ::Telegram::ScheduleBot::GetAnswer.run!(params[:message])
        return render json: {}, status: :ok if text.blank?

        ::Telegram::SendMessage.run!(chat_id: params.dig(:message, :chat, :id), text: text)
        render json: {}, status: :ok
      end
    end
  end
end
