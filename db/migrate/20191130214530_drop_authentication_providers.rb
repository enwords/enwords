class DropAuthenticationProviders < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_authentications, :authentication_provider_id
    drop_table :authentication_providers
  end
end
