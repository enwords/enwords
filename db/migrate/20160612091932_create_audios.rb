class CreateAudios < ActiveRecord::Migration[5.0]
  def change
    create_table :audios, id: false do |t|
      t.references :sentence, index: true, foreign_key: true
    end
  end
end
