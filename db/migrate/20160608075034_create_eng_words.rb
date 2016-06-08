class CreateEngWords < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_words, :id => false) do |t|
      t.integer :id, :options => 'PRIMARY KEY'
      t.string :word
    end
  end
end
