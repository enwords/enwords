FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    role { :user }
    native_language { 'rus' }
    learning_language { 'eng' }
    sentences_number { 3 }
    audio_enable { false }
    diversity_enable { false }
    skyeng_words_count { 15 }
    proficiency_levels { {} }
  end
end
