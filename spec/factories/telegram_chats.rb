FactoryBot.define do
  factory :telegram_chat do
    user
    chat_id { rand(1..1000) }
    username { nil }
    active { true }
  end
end
