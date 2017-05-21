class AddWordsDataToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :words_data, :jsonb, default: {}
  end
end
