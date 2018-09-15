module Telegram
  module ScheduleBot
    class GetAnswer < ActiveInteraction::Base
      string  :text
      integer :message_id
      integer :date

      hash :from do
        integer :id
        boolean :is_bot
        string  :first_name
        string  :last_name
        string  :username
        string  :language_code
      end

      hash :chat do
        integer :id
        string  :first_name
        string  :last_name
        string  :username
        string  :type
      end

      def execute
        word = text.to_s.split(' ').first.downcase.strip

        case word
        when /xoxo/i then 'YOLO!'
        when /[a-z]/i  then Sentence::ByWord.run!(word: word, language: 'eng', translation_language: 'rus').text
        when /[а-ё]/i  then Sentence::ByWord.run!(word: word, language: 'rus', translation_language: 'eng').text
        end
      end
    end
  end
end
