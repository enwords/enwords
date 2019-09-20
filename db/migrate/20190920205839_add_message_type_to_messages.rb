class AddMessageTypeToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :message_type, :integer
  end
end
