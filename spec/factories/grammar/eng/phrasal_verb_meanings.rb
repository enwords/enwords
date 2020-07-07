FactoryBot.define do
  factory :grammar_eng_phrasal_verb_meaning, class: 'Grammar::Eng::PhrasalVerbMeaning' do
    phrasal_verb { create(:grammar_eng_phrasal_verb) }
    value { FFaker::Lorem.sentence }
    example { FFaker::Lorem.sentence }
  end
end
