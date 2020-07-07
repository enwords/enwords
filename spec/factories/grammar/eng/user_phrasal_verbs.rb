FactoryBot.define do
  factory :grammar_eng_user_phrasal_verb, class: 'Grammar::Eng::UserPhrasalVerb' do
    phrasal_verb { create(:grammar_eng_phrasal_verb) }
    user
  end
end
