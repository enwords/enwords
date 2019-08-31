module Telegram
  class SendMessageToSubscriber < ActiveInteraction::Base
    private

    object :user, class: User

    def execute
      return :no_learning_word if learning_word.blank?
      return :no_text if text.blank?

      result = Telegram::SendMessage.run!(
        text: text,
        chat_id: user.telegram_chat.chat_id,
        reply_markup: {
          inline_keyboard: [
            [
              {
                text: I18n.t('words.buttons.add_to_learned', locale: :ru),
                callback_data: { user_id: user.id, word_id: learning_word.id, action: :learned }.to_json
              }
            ]
          ]
        }
      )
      return :ok if result[:ok]

      case result[:error_code]
      when 403 then user.telegram_chat.update!(active: false)
      end
      [:error, result]
    end

    def learning_word
      @learning_word ||= Word::ByStatus.run!(status: 'learning', user: user).sample
    end

    def text
      @text ||= Sentence::ByWord.run!(word: learning_word, translation_lang: :rus)[:text]
    end
  end
end