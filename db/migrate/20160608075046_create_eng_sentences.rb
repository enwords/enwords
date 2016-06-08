class CreateEngSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:eng_sentences, :id => false) do |t|
      t.integer :id, :options => 'PRIMARY KEY'
      t.string :sentence
    end
  end
end
