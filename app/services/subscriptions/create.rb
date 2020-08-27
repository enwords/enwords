module Subscriptions
  class Create < ActiveInteraction::Base
    private

    object :user, class: User
    string :plan

    def execute
      subscription.save!
      [subscription, payment.data.last['confirmation']['confirmation_url']]
    end

    def amount_cents
      @amount_cents ||=
        case plan
        when 'monthly' then 149_00
        when 'yearly' then 990_00
        end
    end

    def payment
      @payment ||= Yandex::Kassa::CreatePayment.run!(
        user: user,
        amount_cents: amount_cents,
        currency: 'RUB'
      )
    end

    def subscription
      @subscription ||= Subscription.new(
        user: user,
        payment: payment,
        plan: plan,
        status: :pending
      )
    end
  end
end
