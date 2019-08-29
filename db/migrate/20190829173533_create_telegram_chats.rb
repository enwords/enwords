class CreateTelegramChats < ActiveRecord::Migration[5.0]
  def change
    create_table :telegram_chats, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.bigint :chat_id, null: false
      t.string :username, null: false
      t.string :first_name
      t.string :last_name
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
