class AddProviderToUserAuthentications < ActiveRecord::Migration[5.2]
  def change
    add_column :user_authentications, :provider, :integer
  end
end
