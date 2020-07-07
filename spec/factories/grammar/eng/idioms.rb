FactoryBot.define do
  factory :grammar_eng_idiom, class: 'Grammar::Eng::Idiom' do
    value { FFaker::Lorem.sentence }
    meaning { FFaker::Lorem.sentence }
  end
end
