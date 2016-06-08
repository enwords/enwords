json.array!(@eng_sentences) do |eng_sentence|
  json.extract! eng_sentence, :id, :id, :sentence
  json.url eng_sentence_url(eng_sentence, format: :json)
end
