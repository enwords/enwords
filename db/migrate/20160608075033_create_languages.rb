class CreateLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table(:languages, :id => false) do |t|
      t.integer :id, :primary_key => true, :unique => true , :null => false
      t.string :name, unique: true
    end
  end
end
