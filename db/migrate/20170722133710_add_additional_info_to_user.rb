class AddAdditionalInfoToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :additional_info, :jsonb, default: {}
  end
end
