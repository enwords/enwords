FactoryBot.define do
  factory :grammar_eng_user_irregular_verb, class: 'Grammar::Eng::UserIrregularVerb' do
    irregular_verb { create(:grammar_eng_irregular_verb) }
    user
  end
end
