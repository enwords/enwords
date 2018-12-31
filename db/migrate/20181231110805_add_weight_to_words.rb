class AddWeightToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :weight, :integer

    Word.update_all('weight = id')
  end
end
