FactoryBot.define do
  factory :word_status do
    word { build :word }
    user { build :user }
    learned true
  end
end
