json.array!(words) do |word|
  json.extract! word, :id, :id, :word
  json.url word_url(word, format: :json)
end
