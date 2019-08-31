module Api
  module Telegram
    class MessagesController < ::Api::BaseController
      def create
        Message.create!(data: params[:callback_query] || params[:message])

        if params[:callback_query]
          ::Telegram::ProcessCallback.run!(params[:callback_query])
        elsif params[:message]
          ::Telegram::ProcessMessage.run!(params[:message])
        end
        render json: {}, status: :ok
      end
    end
  end
end
