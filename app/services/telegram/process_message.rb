module Telegram
  class ProcessMessage < ActiveInteraction::Base
    DEFAULT_LANG = 'eng'.freeze

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
      when '/start' then process_start
      when /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i then process_email
      when '/stop' then process_stop
      when /hello/i then process_hello
      else process_word
      end
    end

    def process_start
      return I18n.t('telegram.process_message.send_email', locale: :ru) unless telegram_chat

      telegram_chat.update!(active: true)
      words_count = Word::ByStatus.run!(status: 'learning', user: telegram_chat_user).size
      I18n.t('telegram.process_message.telegram_chat_created', locale: :ru, words_count: words_count)
    end

    def process_email
      user = User.find_by(email: clean_text)
      return I18n.t('telegram.process_message.user_not_found', locale: :ru) unless user

      create_telegram_chat(user)
      words_count = Word::ByStatus.run!(status: 'learning', user: user).size
      I18n.t('telegram.process_message.telegram_chat_created', locale: :ru, words_count: words_count)
    end

    def process_stop
      telegram_chat&.update!(active: false)
      I18n.t('telegram.process_message.bye', locale: :ru)
    end

    def process_hello
      'Hey. You are awesome!'
    end

    def process_word
      unless word
        return I18n.t('telegram.process_message.only_one_word', locale: :ru) if clean_text.split(' ').size > 1

        return I18n.t('telegram.process_message.go_premium', locale: :ru) unless telegram_chat_user.premium?

        return I18n.t('telegram.process_message.not_understand', locale: :ru)
      end

      update_word_status
      texts_by_word[:text]
    end

    def texts_by_word
      @texts_by_word ||= Sentence::ByWord.run!(word: word, translation_lang: translation_lang)
    end

    def translation_lang
      @translation_lang ||=
        if lang == telegram_chat_user&.learning_language
          telegram_chat_user&.native_language || DEFAULT_LANG
        else
          telegram_chat_user&.learning_language || DEFAULT_LANG
        end
    end

    def lang
      @lang ||= word.language
    end

    def clean_text
      return if text.blank?

      @clean_text ||= text.mb_chars.downcase.to_s.strip
    end

    def word
      @word ||= Word.where(
        value: clean_text,
        language: [telegram_chat_user.learning_language, telegram_chat_user.native_language, DEFAULT_LANG]
      ).first
    end

    def translation_object
      @translation_object ||=
        if texts_by_word[:word_translation]
          Word.find_by(value: texts_by_word[:word_translation].downcase, language: translation_lang)
        end
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

    def telegram_chat_user
      @telegram_chat_user ||= telegram_chat.user
    end

    def update_word_status
      return unless telegram_chat

      if word && word.language == telegram_chat_user.learning_language
        Word::UpdateState.run(ids: [word.id], to_state: 'learning', user: telegram_chat_user)
      elsif translation_object && translation_object.language == telegram_chat_user.learning_language
        Word::UpdateState.run(ids: [translation_object.id], to_state: 'learning', user: telegram_chat_user)
      end
    end
  end
end
