module Telegram
  class SendExternalArticleWorker
    include Sidekiq::Worker

    def perform(*)
      user = User.first
      return unless user

      text = ExternalArticle.all.sample&.url
      return unless text

      Telegram::SendMessage.run!(text: text, chat_id: user.telegram_chat.chat_id)
      :ok
    end
  end
end
