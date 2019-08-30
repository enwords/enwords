module Api
  module Telegram
    class MessagesController < ::Api::BaseController
      def create
        return render json: {}, status: :ok unless params[:message]

        ::Telegram::ProcessMessage.run!(params[:message]) if params[:message]
        ::Telegram::ProcessCallback.run!(params[:message]) if params[:callback_query]
        render json: {}, status: :ok
      end
    end
  end
end
