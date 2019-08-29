class CreateWordStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table(:word_statuses, id: false) do |t|
      t.references :user
      t.references :word

      t.boolean :learned, null: false
    end
    add_index :word_statuses, %i[user_id word_id], unique: true
  end
end
