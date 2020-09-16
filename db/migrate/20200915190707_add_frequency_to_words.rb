class AddFrequencyToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :frequency, :integer
  end
end
