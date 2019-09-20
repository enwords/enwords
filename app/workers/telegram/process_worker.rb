module Telegram
  class ProcessWorker
    include Sidekiq::Worker

    def perform(message_id)
      message = Message.find_by(id: message_id)
      return unless message

      case message.message_type&.to_sym
      when :message
        ::Telegram::ProcessMessage.run!(message.data)
      when :callback_query
        ::Telegram::ProcessCallback.run!(message.data)
      end
    end
  end
end
