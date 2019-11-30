class User < ApplicationRecord
  class SendPromoEmail < ActiveInteraction::Base
    private

    integer :limit

    def execute
      users.find_each do |user|
        ApplicationMailer.telegram_bot_email(user.email).deliver_now
        user.update!(promo_email_sent: true)
      end
      :ok
    end

    def users
      @users ||=
        User
        .where(native_language: :rus, learning_language: :eng, promo_email_sent: false)
        .where('created_at < ?', 30.days.ago)
        .where("email NOT SIMILAR TO '%@(vk.com|facebook.com|twitter.com)'")
        .limit(limit)
    end
  end
end
