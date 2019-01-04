class CreateMnemos < ActiveRecord::Migration[5.0]
  def change
    create_table :mnemos, id: :uuid do |t|
      t.belongs_to :word
      t.string :language
      t.string :content

      t.timestamps
    end
  end
end
