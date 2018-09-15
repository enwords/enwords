module Api
  module Telegram
    class ScheduleBotsController < ActionController::Base
      def message
        ActionMailer::Base.mail(to: 'sadovnikov.js@gmail.com', from: 'sadovnikov.js@gmail.com', subject: 'Enwords', body: params.to_json).deliver

        return render json: {}, status: :ok unless params[:message]

        text = ::Telegram::ScheduleBot::GetAnswer.run!(params[:message])
        ActionMailer::Base.mail(to: 'sadovnikov.js@gmail.com', from: 'sadovnikov.js@gmail.com', subject: 'Enwords', body: text.to_s).deliver

        ::Telegram::ScheduleBot::Reply.run!(
          chat_id: params.dig(:message, :chat, :id), text: text
        )
        render json: {}, status: :ok
      end
    end
  end
end
