class AddDataToTrainings < ActiveRecord::Migration[5.0]
  def change
    change_table :trainings do |t|
      t.jsonb :data
      t.string :type
      t.remove :word_ids
      t.remove :sentence_ids
      t.remove :training_type
    end
  end
end
