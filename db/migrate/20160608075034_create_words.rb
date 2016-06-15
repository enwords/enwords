class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table(:words, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.references :language, index: true, foreign_key: true
      t.string :word, unique: true
    end
  end
end
