class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.integer :amount_cents, null: false
      t.string :currency, null: false
      t.integer :provider, null: false
      t.integer :status, null: false
      t.jsonb :data
      t.timestamps
    end
  end
end
