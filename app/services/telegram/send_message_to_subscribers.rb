module Telegram
  class SendMessageToSubscribers < ActiveInteraction::Base
    private

    def execute
      users.find_each { |user| SendMessageToSubscriber.run!(user: user) }
      :ok
    end

    def users
      @users ||= User.joins(:telegram_chat).where(telegram_chats: { active: true })
    end
  end
end
