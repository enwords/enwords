FactoryBot.define do
  factory :grammar_eng_phrasal_verb, class: 'Grammar::Eng::PhrasalVerb' do
    value { FFaker::Lorem.sentence }
  end
end
