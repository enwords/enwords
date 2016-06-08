json.array!(@eng_words) do |eng_word|
  json.extract! eng_word, :id, :id, :word
  json.url eng_word_url(eng_word, format: :json)
end
