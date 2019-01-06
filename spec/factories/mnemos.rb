FactoryBot.define do
  factory :mnemo do
    word { build :word }
    language 'rus'
    value 'Контент'
  end
end
