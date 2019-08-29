class CreateWordInArticles < ActiveRecord::Migration[5.0]
  def change
    create_table(:word_in_articles, id: false) do |t|
      t.references :article
      t.references :word
      t.integer :frequency
    end
    add_index :word_in_articles, %i[article_id word_id], unique: true
  end
end
