json.array!(@sentences) do |sentence|
  json.extract! sentence, :id, :sentence
  json.url sentence_url(sentence, format: :json)
end
