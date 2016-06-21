class CreateTrainings < ActiveRecord::Migration[5.0]
  create_table(:trainings, :id => false) do |t|
    t.references :user
    t.references :sentence
  end
end
