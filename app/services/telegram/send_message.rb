module Telegram
  class SendMessage < BaseRequest
    integer :chat_id
    string :text
    symbol :parse_mode, default: :markdown

    def execute
      options = { chat_id: chat_id, text: text }
      options[:parse_mode] = parse_mode if parse_mode
      response('sendMessage', options)
    end
  end
end
