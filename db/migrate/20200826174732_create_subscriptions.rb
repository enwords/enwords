class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :payment, foreign_key: true, null: false, type: :uuid
      t.integer :status, null: false
      t.integer :plan, null: false
      t.datetime :expires_at
      t.timestamps
    end
  end
end
