class AddDataToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :data, :jsonb
  end
end
