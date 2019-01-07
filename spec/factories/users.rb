FactoryBot.define do
  factory :user do
    email { 'test@mail.ru' }
    password { 'password1234' }
    role { 'user' }
    native_language { 'rus' }
    learning_language { 'eng' }
    sentences_number { 3 }
    audio_enable { false }
    diversity_enable { false }
    skyeng_words_count { 15 }
    proficiency_levels { {} }
  end
end
