class CreateSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:sentences, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :sentence
      t.string :language, limit: 4
    end
  end
end
