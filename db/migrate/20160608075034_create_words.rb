class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table(:words, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :word, unique: true
      t.string :language, limit: 4
    end
  end
end
