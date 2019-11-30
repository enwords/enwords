module Mailer
  class SendPromoEmailWorker
    include Sidekiq::Worker

    def perform(limit = ENV.fetch('PROMO_EMAIL_LIMIT', 5))
      User::SendPromoEmail.run!(limit: limit)
      :ok
    end
  end
end
