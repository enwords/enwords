class CreateJoinTableBookWord < ActiveRecord::Migration[5.0]
  def change
    create_join_table :books, :words do |t|
      # t.index [:book_id, :word_id]
      # t.index [:word_id, :book_id]
    end
    add_index :books_words, [:book_id, :word_id], unique: true
  end
end
