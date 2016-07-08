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

CSV.foreach(Rails.root.join('db', 'seeds_data', 'words.tsv'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|

  sql = "insert into words (id, language, word) values (#{row[0]}, '#{row[1]}', '#{row[2]}')"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'words done'

CSV.foreach(Rails.root.join('db', 'seeds_data', 'sentences.tsv'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into sentences (id, language, sentence) values (#{row[0]}, '#{row[1]}', '#{row[2]}')"
  # sql = "insert into sentences (id, language, sentence) values (#{row[0]}, '" + row[1]+ "', '"+ row[2] + "')"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'sentences done'

CSV.foreach(Rails.root.join('db', 'seeds_data', 'word_sentence.tsv'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into sentences_words (word_id, sentence_id) values (#{row[0]}, #{row[1]})"
  # sql = "insert into sentences_words (word_id, sentence_id) values (#{row[0]}, #{row[1]})"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'word_sentence done'


CSV.foreach(Rails.root.join('db', 'seeds_data', 'audio.tsv'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into audios (sentence_id) values (#{ row[0]})"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'audio done'

CSV.foreach(Rails.root.join('db', 'seeds_data', 'links.tsv'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into links (sentence_1_id, sentence_2_id) values (#{ row[0]}, #{row[1]})"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'links done'