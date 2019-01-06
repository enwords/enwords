class AddPosToWords < ActiveRecord::Migration[5.0]
  def up
    add_column :words, :pos, :string

    csv_text = File.read(Rails.root.join('db', 'seeds_data', 'pos.csv'))
    csv      = CSV.parse(csv_text, col_sep: ';', headers: false, encoding: 'utf-8')
    csv.each do |row|
      word = Word.where(language: 'eng', value: row[0]).first
      next unless word
      word.update(pos: row[1])
    end
  end

  def down
    remove_column :words, :pos
  end
end
