FactoryBot.define do
  factory :grammar_eng_irregular_verb, class: 'Grammar::Eng::IrregularVerb' do
    infinitive { FFaker::Lorem.sentence }
  end
end
