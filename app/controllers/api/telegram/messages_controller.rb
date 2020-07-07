module API
  module Telegram
    class MessagesController < ::API::BaseController
      def create
        message = Message.create!(data: params[:callback_query] ||
                                        params[:message], message_type: message_type)
        ::Telegram::ProcessWorker.perform_async(message.id)
        render json: {}, status: :ok
      end

      private

      def message_type
        @message_type ||= params[:callback_query] ? :callback_query : :message
      end
    end
  end
end
