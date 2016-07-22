class CreateWordbooks < ActiveRecord::Migration[5.0]
  def change
    create_table(:wordbooks, :id => false) do |t|
      t.references :book
      t.references :word
      t.integer :rate
    end
    add_index :wordbooks, [:book_id, :word_id], unique: true
  end
end