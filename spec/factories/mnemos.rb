FactoryBot.define do
  factory :mnemo do
    word { build :word }
    language 'rus'
    content 'Контент'
  end
end
