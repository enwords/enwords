class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table(:words, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :language, limit: 4
      t.string :word, unique: true
    end
    add_index :words, :language
  end
end
