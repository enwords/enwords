module Subscriptions
  class Activate < ActiveInteraction::Base
    private

    object :subscription

    def execute
      return subscription unless subscription.status_pending?

      if payment.status_succeeded?
        subscription.expires_at = expires_at
        subscription.status_active!
      elsif payment.status_canceled?
        subscription.status_canceled!
      end
      subscription
    end

    def expires_at
      return 1.year.from_now if subscription.plan_yearly?
      return 1.month.from_now if subscription.plan_monthly?
    end

    def payment
      @payment ||= Yandex::Kassa::CheckPayment.run!(payment: subscription.payment)
    end
  end
end
