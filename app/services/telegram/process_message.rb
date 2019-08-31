module Telegram
  class ProcessMessage < ActiveInteraction::Base
    private

    string :text, default: nil
    integer :message_id
    integer :date

    hash :from do
      integer :id
      boolean :is_bot
      string :first_name, default: nil
      string :last_name, default: nil
      string :username, default: nil
      string :language_code, default: nil
    end

    hash :chat do
      integer :id
      string :first_name, default: nil
      string :last_name, default: nil
      string :username, default: nil
      string :type
    end

    def execute
      SendMessage.run!(text: response_text, chat_id: chat[:id])
    end

    def response_text
      case clean_text
      when '/start'
        if telegram_chat
          words_count = Word::ByStatus.run!(status: 'learning', user: telegram_chat.user, with_offset: false).size
          I18n.t('telegram.process_message.telegram_chat_created', locale: :ru, words_count: words_count)
        else
          I18n.t('telegram.process_message.send_email', locale: :ru)
        end
      when /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        user = User.find_by(email: clean_text)
        return I18n.t('telegram.process_message.user_not_found', locale: :ru) unless user

        create_telegram_chat(user)
        words_count = Word::ByStatus.run!(status: 'learning', user: user, with_offset: false).size
        I18n.t('telegram.process_message.telegram_chat_created', locale: :ru, words_count: words_count)
      when '/stop'
        telegram_chat&.update!(active: false)
        I18n.t('telegram.process_message.bye', locale: :ru)
      when /xoxo/i
        'YOLO!'
      else
        return I18n.t('telegram.process_message.not_understand', locale: :ru) unless word

        update_word_status
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
      return if text.blank?

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

    def update_word_status
      return unless word
      return unless telegram_chat

      user = telegram_chat.user
      return if word.language != user.learning_language

      Word::UpdateState.run(ids: [word.id], to_state: 'learning', user: user)
    end
  end
end
