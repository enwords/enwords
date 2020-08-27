FactoryBot.define do
  factory :payment do
    user
    amount_cents { rand(1_00..100_00) }
    currency { 'RUB' }
    provider { Payment.providers.keys.sample }
    status { Payment.statuses.keys.sample }
    data { [] }
  end
end
