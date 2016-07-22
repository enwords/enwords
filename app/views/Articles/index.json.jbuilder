json.array!(articles) do |article|
  json.extract! article, :id, :user_id, :language, :content, :title
  json.url article_url(article, format: :json)
end
