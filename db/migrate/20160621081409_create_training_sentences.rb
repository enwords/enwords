class CreateTrainingSentences < ActiveRecord::Migration[5.0]
  create_table(:training_sentences, id: false) do |t|
    t.references :user
    t.references :sentence
  end
end
