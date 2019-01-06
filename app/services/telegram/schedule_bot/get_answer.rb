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
        case word_string
        when /xoxo/i
          'YOLO!'
        else
          Sentence::ByWord.run!(word: word, trans_lang: trans_lang).text
        end
      end

      def trans_lang
        @trans_lang ||=
          case lang
          when 'rus' then 'eng'
          when 'eng' then 'rus'
          end
      end

      def lang
        @lang ||=
          case word_string
          when /[a-z]/i then 'eng'
          when /[а-ё]/i then 'rus'
          end
      end

      def word_string
        @word_string ||= text.to_s.split(' ').first.mb_chars.downcase.to_s.strip
      end

      def word
        @word ||= Word.find_by(value: word_string, language: lang)
      end
    end
  end
end
