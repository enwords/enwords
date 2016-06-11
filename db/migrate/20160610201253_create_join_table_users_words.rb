class CreateJoinTableUsersWords < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :words do |t|
      # t.index [:user_id, :word_id]
      # t.index [:word_id, :user_id]
      t.boolean :is_learned
    end
  end
end
