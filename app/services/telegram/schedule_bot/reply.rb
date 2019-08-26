module Telegram
  module ScheduleBot
    class Reply < ActiveInteraction::Base
      string :text, default: nil
      integer :chat_id
      string :parse_mode, default: 'markdown'

      def execute
        return :no_text unless text

        HTTParty.post(
          ENV['TELEGRAM_API_SHORT_URL'],
          body: inputs.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
    end
  end
end
