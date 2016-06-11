json.array!(@word_collections) do |word_collection|
  json.extract! word_collection, :id, :user_id
  json.url word_collection_url(word_collection, format: :json)
end
