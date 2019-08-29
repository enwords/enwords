module Telegram
  class SendMessageToSubscribersWorker
    include Sidekiq::Worker

    def perform(*)
      SendMessageToSubscribers.run!
    end
  end
end
