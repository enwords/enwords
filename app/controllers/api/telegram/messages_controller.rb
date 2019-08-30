module Api
  module Telegram
    class MessagesController < ::Api::BaseController
      def create
        return render json: {}, status: :ok unless params[:message]

        ::Telegram::ProcessMessage.run!(params[:message])
        render json: {}, status: :ok
      end
    end
  end
end
