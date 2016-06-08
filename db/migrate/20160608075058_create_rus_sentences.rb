class CreateRusSentences < ActiveRecord::Migration[5.0]
  def change
    create_table(:rus_sentences, :id => false) do |t|
      t.integer :id, :options => 'PRIMARY KEY'
      t.string :sentence
    end
  end
end
