FactoryBot.define do
  factory :payment_log do
    provider { PaymentLog.providers.keys.sample }
    payment_type { PaymentLog.payment_types.keys.sample }
  end
end
