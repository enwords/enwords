class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links, id: false do |t|
      t.integer :sentence_1_id, index: true, foreign_key: true, :null => false
      t.integer :sentence_2_id, index: true, foreign_key: true, :null => false
    end
    add_index :links, [:sentence_1_id, :sentence_2_id], unique: true
  end
end
