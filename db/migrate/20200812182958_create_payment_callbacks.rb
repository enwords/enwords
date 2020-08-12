class CreatePaymentCallbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_callbacks, id: :uuid do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
