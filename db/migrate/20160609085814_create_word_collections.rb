class CreateWordCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :word_collections do |t|
      t.string :name, null: false, default: t.timestamps.to_s
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
