class CreateTrainings < ActiveRecord::Migration[5.0]
  def change
    create_table :trainings do |t|
      t.references :user, index: true, foreign_key: true
      t.integer    :word_ids,      array: true, default: []
      t.integer    :sentence_ids,  array: true, default: []
      t.string     :training_type, null: false
      t.integer    :words_learned, default: 0, null: false
      t.integer    :current_page,  default: 1, null: false
    end
  end
end
