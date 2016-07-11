class CreateJoinTableCollectionsWords < ActiveRecord::Migration[5.0]
  def change
    create_join_table :collections, :words  do |t|
      # t.index [:word_id, :collection_id]
      # t.index [:collection_id, :word_id]
    end
  end
end
