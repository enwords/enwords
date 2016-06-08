json.array!(@rus_sentences) do |rus_sentence|
  json.extract! rus_sentence, :id, :id, :sentence
  json.url rus_sentence_url(rus_sentence, format: :json)
end
