# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
require 'csv'

Language.create! [
                     {id: 1, name: 'eng'},
                     {id: 2, name: 'rus'}
                 ]

User.create! [
                 {id: 1, email: 'qqq@qqq.qqq', password: 'qqqqqq'},
                 {id: 2, email: 'qqq@qqq2.qqq', password: 'qqqqqq'}
             ]

CSV.foreach(Rails.root.join('db', 'seeds_data', 'engWords.txt'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|

  sql = "insert into words (id, language_id, word) values (#{ row[0]}, 1, "+ "'" + row[1].gsub("'", "''") + "')" #SET Lang ID!
  ActiveRecord::Base.connection.execute(sql)
end
puts 'words done'

CSV.foreach(Rails.root.join('db', 'seeds_data', 'sentences.csv'), :col_sep => ";", :headers => false,
            :encoding => 'utf-8').each do |row|
  # puts  row[0]
  # # puts  row[1]
  # puts  row[2]
  sql = "insert into sentences (id, language_id, sentence) values (#{row[0]}, #{row[1]}, "+ "'" + row[2].gsub("'", "''") + "')"
  puts sql
  ActiveRecord::Base.connection.execute(sql)
end
puts 'sentences done'

CSV.foreach(Rails.root.join('db', 'seeds_data', 'engWordSentenceLinks.txt'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into sentences_words (word_id, sentence_id) values (#{row[0]}, #{row[1]})"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'words_sentences done'


CSV.foreach(Rails.root.join('db', 'seeds_data', 'audioLinks.txt'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into audio (sentence_id) values (#{ row[0]})"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'links done'

CSV.foreach(Rails.root.join('db', 'seeds_data', 'audioLinks.txt'), :col_sep => "\t", :headers => false,
            :encoding => 'utf-8').each do |row|
  sql = "insert into links (sentence_1_id, sentence_2_id) values (#{ row[0]}, #{row[1]})"
  ActiveRecord::Base.connection.execute(sql)
end
puts 'audio done'