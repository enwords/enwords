class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
