class SetWeightToWords < ActiveRecord::Migration[5.0]
  def up
    Word.update_all('weight = id')
  end

  def down
    Word.update_all(weight: nil)
  end
end
