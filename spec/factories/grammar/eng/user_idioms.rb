FactoryBot.define do
  factory :grammar_eng_user_idiom, class: 'Grammar::Eng::UserIdiom' do
    idiom { create(:grammar_eng_idiom) }
    user
  end
end
