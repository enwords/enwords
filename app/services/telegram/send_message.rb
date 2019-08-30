module Telegram
  class SendMessage < BaseRequest
    integer :chat_id
    string :text
    symbol :parse_mode, default: :markdown
    hash :reply_markup, default: {}, strip: false

    def execute
      options = { chat_id: chat_id, text: text }
      options[:parse_mode] = parse_mode if parse_mode
      options[:reply_markup] = reply_markup.to_json if reply_markup.present?
      response('sendMessage', options)
    end
  end
end
