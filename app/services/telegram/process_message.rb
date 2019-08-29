module Telegram
  class ProcessMessage < ActiveInteraction::Base
    private

    string :text
    integer :message_id
    integer :date

    hash :from do
      integer :id
      boolean :is_bot
      string :first_name
      string :last_name
      string :username
      string :language_code, default: nil
    end

    hash :chat do
      integer :id
      string :first_name
      string :last_name
      string :username
      string :type
    end

    def execute
      SendMessage.run!(text: response_text, chat_id: chat[:id])
    end

    def response_text
      case clean_text
      when '/start'
        if telegram_chat
          I18n.t('telegram.process_message.telegram_chat_created',
                 locale: :ru,
                 words_count: Word::ByStatus.run!(status: 'learning', user: telegram_chat.user).size)
        else
          I18n.t('telegram.process_message.send_email', locale: :ru)
        end
      when /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        user = User.find_by(email: clean_text)
        return I18n.t('telegram.process_message.user_not_found', locale: :ru) unless user

        create_telegram_chat(user)
        I18n.t('telegram.process_message.telegram_chat_created',
               locale: :ru,
               words_count: Word::ByStatus.run!(status: 'learning', user: user).size)
      when '/stop'
        telegram_chat&.update!(active: false)
        I18n.t('telegram.process_message.bye', locale: :ru)
      when /xoxo/i
        'YOLO!'
      else
        return I18n.t('telegram.process_message.not_understand', locale: :ru) unless word

        Sentence::ByWord.run!(word: word, translation_lang: translation_lang)[:text]
      end
    end

    def translation_lang
      @translation_lang ||=
        case lang
        when :rus then :eng
        when :eng then :rus
        end
    end

    def lang
      @lang ||=
        case clean_text
        when /[a-z]/i then :eng
        when /[а-ё]/i then :rus
        end
    end

    def clean_text
      @clean_text ||= text.mb_chars.downcase.to_s.strip
    end

    def word
      @word ||= Word.find_by(value: clean_text, language: lang)
    end

    def telegram_chat
      @telegram_chat ||= TelegramChat.find_by(chat_id: chat[:id])
    end

    def create_telegram_chat(user)
      @telegram_chat = begin
        result = TelegramChat.find_or_initialize_by(
          user: user,
          chat_id: chat[:id],
          username: chat[:username],
          first_name: chat[:first_name],
          last_name: chat[:last_name]
        )
        result.update!(active: true)
      end
    end
  end
end
