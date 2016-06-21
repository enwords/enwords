# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

Language.create! [
                     {id: 1, name: 'eng'},
                     {id: 2, name: 'rus'}
                 ]

User.create! [
    {id: 1,	email: 'qqq@qqq.qqq', 	password: 'qqqqqq'}, #$2a$11$Zf5x.t4VjysM6Ddcr8K3YOhYyWyZxjyxPGofFoPs1BTEu2WUKY5Fy
    {id: 2,	email: 'qqq@qqq2.qqq', 	password: 'qqqqqq'}
             ]


Word.create! [
                 {id: 1, language_id: 1, word: 'is'},
                 {id: 2, language_id: 1, word: 'my'},
                 {id: 3, language_id: 1, word: 'go'},
                 {id: 4, language_id: 1, word: 'hello'},
                 {id: 5, language_id: 1, word: 'name'},
                 {id: 6, language_id: 1, word: 'to'},
                 {id: 7, language_id: 1, word: 'home'},
                 {id: 8, language_id: 1, word: 'baby'},
                 {id: 9, language_id: 1, word: 'the'},
                 {id: 10, language_id: 1, word: 'bad'},
                 {id: 11, language_id: 2, word: 'слово'},
                 {id: 12, language_id: 2, word: 'жизнь'},
                 {id: 13, language_id: 1, word: 'this'},
                 {id: 14, language_id: 1, word: 'have'},
                 {id: 15, language_id: 1, word: 'me'},
                 {id: 16, language_id: 1, word: 'my'},
                 {id: 17, language_id: 1, word: 'what'},
                 {id: 18, language_id: 1, word: 'and'},
                 {id: 19, language_id: 1, word: 'do'},
                 {id: 20, language_id: 1, word: 'be'},
                 {id: 21, language_id: 1, word: 'we'},
                 {id: 22, language_id: 1, word: 'are'},
                 {id: 23, language_id: 1, word: 'with'},
             ]

Sentence.create! [
                     {id: 1, language_id: 1, sentence: 'Hello my name is Dima'},
                     {id: 2, language_id: 1, sentence: 'Go to home baby'},
                     {id: 3, language_id: 1, sentence: 'His car is bad'},
                     {id: 4, language_id: 1, sentence: 'I work alone'},
                     {id: 5, language_id: 1, sentence: 'You are the bad'},
                     {id: 6, language_id: 2, sentence: 'Привет меня зовут Дима'},
                     {id: 7, language_id: 2, sentence: 'Иди домой лол'},
                     {id: 8, language_id: 2, sentence: 'Его автомобиль не очень хороший'},
                     {id: 9, language_id: 2, sentence: 'Я тружусь в одиночестве'},
                     {id: 10, language_id: 2, sentence: 'Ты - кровать'}
                 ]

arr = [[1, 1], [1, 3], [2, 1], [3, 2], [4, 1], [11, 7], [11, 8], [12, 8], [12, 9]]
arr.each do |x|
  sql = "insert into sentences_words (word_id, sentence_id) values (#{x.join(", ")})"
  ActiveRecord::Base.connection.execute(sql)
end


(1...10).each do |x|
  ActiveRecord::Base.connection.execute("insert into audio (sentence_id) values (#{x})") if x.even?
end

(1..5).each do |x|
  y ||= 6
  ActiveRecord::Base.connection.execute("insert into links (sentence_1_id, sentence_2_id) values (#{x}, #{y})")
  y = y + 1
end


val = [
    {user_id: 1, word_id: 10, learned: false},
    {user_id: 2, word_id: 3, learned: true},
    {user_id: 2, word_id: 7, learned: true},
    {user_id: 1, word_id: 9, learned: true}
]
Wordbook.create! val