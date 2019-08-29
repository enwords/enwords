class CreateTrainingWords < ActiveRecord::Migration[5.0]
  create_table(:training_words, id: false) do |t|
    t.references :user
    t.references :word
  end
end
