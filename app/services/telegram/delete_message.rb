module Telegram
  class DeleteMessage < BaseRequest
    integer :chat_id
    integer :message_id

    def execute
      options = { chat_id: chat_id, message_id: message_id }
      response('deleteMessage', options)
    end
  end
end
