class CreatePaymentLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_logs, id: :uuid do |t|
      t.integer :provider, null: false
      t.integer :payment_type, null: false
      t.jsonb :data
      t.timestamps
    end
  end
end
