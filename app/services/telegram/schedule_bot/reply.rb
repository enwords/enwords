module Telegram
  module ScheduleBot
    class Reply < ActiveInteraction::Base
      string  :text, default: nil
      integer :chat_id

      def execute
        return :no_text unless text
        Net::HTTP.post_form(url, inputs)
      end

      def url
        URI.parse("https://api.telegram.org/bot#{ENV['TELEGRAM_SCHEDULE_BOT_KEY']}/sendMessage")
      end
    end
  end
end
