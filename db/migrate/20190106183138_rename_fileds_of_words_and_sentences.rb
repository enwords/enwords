class RenameFiledsOfWordsAndSentences < ActiveRecord::Migration[5.0]
  def change
    rename_column :sentences, :sentence, :value
    rename_column :mnemos, :content, :value
    rename_column :words, :word, :value
    add_index :words, :value
  end
end
