class CreateTrainings < ActiveRecord::Migration[5.0]
  create_table(:trainings, :id => false) do |t|
    t.references :user
    t.references :sentence
  end
  add_index :trainings, [:user_id, :sentence_id], unique: true
end
