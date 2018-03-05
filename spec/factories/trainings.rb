FactoryBot.define do
  factory :training do
    user { build :user }
    word_ids { (build_list :eng_word, 3).map(&:id) }
    sentence_ids { (build_list :eng_sentence, 3).map(&:id) }
    training_type { 'grammar' }
    words_learned { 2541 }
    current_page { 1 }
  end
end
