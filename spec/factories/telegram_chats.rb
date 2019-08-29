FactoryBot.define do
  factory :telegram_chat do
    user
    chat_id { rand(1..1000) }
    username { SecureRandom.uuid }
    active { true }
  end
end
