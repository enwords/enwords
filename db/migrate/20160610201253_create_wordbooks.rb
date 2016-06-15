class CreateWordbooks < ActiveRecord::Migration[5.0]
  def change
    create_table(:wordbooks, :id => false) do |t|
      t.references :user
      t.references :word

      t.boolean :learned, null: false
    end
    add_index :wordbooks, [:user_id, :word_id], unique: true
  end
end
