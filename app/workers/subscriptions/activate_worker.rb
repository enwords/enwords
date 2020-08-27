module Subscriptions
  class ActivateWorker
    include Sidekiq::Worker

    def perform
      Subscription.status_pending.find_each { |s| Activate.run!(subscription: s) }
    end
  end
end
