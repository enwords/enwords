class ChangeTelegramChatsUsernameDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_null :telegram_chats, :username, from: false, to: true
  end
end
