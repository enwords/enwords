# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
cc = "insert into languages (id, name) values (1, 'eng');"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into languages (id, name) values (2, 'rus');"
ActiveRecord::Base.connection.execute(cc)


Sentence.create! [
                     {id: 1, language_id: 1, sentence: 'Hello my name is Dima'},
                     {id: 2, language_id: 1, sentence: 'Go to home baby'},
                     {id: 3, language_id: 1, sentence: 'His car is bad'},
                     {id: 4, language_id: 1, sentence: 'I work alone'},
                     {id: 5, language_id: 1, sentence: 'You are the bad'},
                     {id: 6, language_id: 1, sentence: 'Привет меня зовут Дима'},
                     {id: 7, language_id: 1, sentence: 'Иди домой лол'},
                     {id: 8, language_id: 1, sentence: 'Его автомобиль не очень хороший'},
                     {id: 9, language_id: 1, sentence: 'Я тружусь в одиночестве'},
                     {id: 10, language_id: 1, sentence: 'Ты - кровать'}
                 ]

cc = "insert into audio (sentence_id) values (2);"
ActiveRecord::Base.connection.execute(cc)

cc = "insert into audio (sentence_id) values (4);"
ActiveRecord::Base.connection.execute(cc)

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
                 {id: 10, language_id: 1, word: 'bad'}

             ]



cc = "insert into users_words (word_id, user_id, learned) values (4, 1, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into users_words (word_id, user_id, learned) values (5, 1, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into users_words (word_id, user_id, learned) values (9, 1, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into users_words (word_id, user_id, learned) values (3, 2, true);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into users_words (word_id, user_id, learned) values (4, 2, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into users_words (word_id, user_id, learned) values (6, 2, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into users_words (word_id, user_id, learned) values (8, 2, true);"
ActiveRecord::Base.connection.execute(cc)