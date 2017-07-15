class CreateSkyengSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :skyeng_settings do |t|
      t.references :user
      t.string :aasm_state
      t.string :email, null: false
      t.string :token
    end
  end
end
