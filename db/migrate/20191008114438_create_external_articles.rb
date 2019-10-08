class CreateExternalArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :external_articles, id: :uuid do |t|
      t.string :title
      t.string :url
      t.string :source
      t.string :author
      t.date :date
      t.timestamps
    end
  end
end
