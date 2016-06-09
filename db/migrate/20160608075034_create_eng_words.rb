class CreateEngWords < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_words, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :word
    end
  end
end
