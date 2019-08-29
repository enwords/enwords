module Telegram
  class SendMessageToSubscriber < ActiveInteraction::Base
    private

    object :user, class: User

    def execute
      return :no_learning_word if learning_word.blank?
      return :no_text if text.blank?

      Telegram::SendMessage.run!(text: text, chat_id: user.telegram_chat.chat_id)
    end

    def learning_word
      @learning_word ||= Word::ByStatus.run!(status: 'learning', user: user).sample
    end

    def text
      @text ||= Sentence::ByWord.run!(word: learning_word, translation_lang: :rus)[:text]
    end
  end
end
