# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
require 'csv'

puts 'wait few minutes'

csv_text = File.read(Rails.root.join('db', 'seeds_data', 'words.tsv'))
csv = CSV.parse(csv_text, :col_sep => "\t", :headers => false, :encoding => 'utf-8')
csv.each do |row|
   Word.create!(id: row[0], language: row[1], word: row[2])
end
puts 'words done'

csv_text = File.read(Rails.root.join('db', 'seeds_data', 'sentences.tsv'))
csv = CSV.parse(csv_text, :col_sep => "\t", :headers => false, :encoding => 'utf-8')
csv.each do |row|
  Sentence.create!(id: row[0], language: row[1], sentence: row[2])
end
puts 'sentences done'

csv_text = File.read(Rails.root.join('db', 'seeds_data', 'word_sentence.tsv'))
csv = CSV.parse(csv_text, :col_sep => "\t", :headers => false, :encoding => 'utf-8')
csv.each do |row|
  SentencesWord.create!(word_id: row[0], sentence_id: row[1])
end
puts 'word_sentence done'

csv_text = File.read(Rails.root.join('db', 'seeds_data', 'audio.tsv'))
csv = CSV.parse(csv_text, :col_sep => "\t", :headers => false, :encoding => 'utf-8')
csv.each do |row|
  Sentence.find_by!(id: row[0]).update!(with_audio: true)
end
puts 'audio done'

csv_text = File.read(Rails.root.join('db', 'seeds_data', 'links.tsv'))
csv = CSV.parse(csv_text, :col_sep => "\t", :headers => false, :encoding => 'utf-8')
csv.each do |row|
  Link.create!(sentence_1_id: row[0], sentence_2_id: row[1])
end
puts 'links done'