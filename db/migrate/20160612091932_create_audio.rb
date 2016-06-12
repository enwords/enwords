class CreateAudio < ActiveRecord::Migration[5.0]
  def change
    create_table :audio, id: false do |t|
      t.references :sentence, index: true, foreign_key: true
    end
  end
end
