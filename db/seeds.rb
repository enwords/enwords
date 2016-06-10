# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#


EngWord.create! [
                    {id: 1, word: 'is'},
                    {id: 2, word: 'my'},
                    {id: 3, word: 'go'},
                    {id: 4, word: 'hello'},
                    {id: 5, word: 'name'},
                    {id: 6, word: 'to'},
                    {id: 7, word: 'home'},
                    {id: 8, word: 'baby'},
                    {id: 9, word: 'the'},
                    {id: 10, word: 'bad'}

                ]

EngSentence.create! [
                        {id: 1, sentence: 'Hello my name is Dima', is_audio: false},
                        {id: 2, sentence: 'Go to home baby', is_audio: true},
                        {id: 3, sentence: 'His car is bad', is_audio: false},
                        {id: 4, sentence: 'I work alone', is_audio: true},
                        {id: 5, sentence: 'You are the bad', is_audio: false}
                    ]

RusSentence.create! [
                        {id: 6, sentence: 'Привет меня зовут Дима', is_audio: false},
                        {id: 7, sentence: 'Иди домой лол', is_audio: true},
                        {id: 8, sentence: 'Его автомобиль не очень хороший', is_audio: false},
                        {id: 9, sentence: 'Я тружусь в одиночестве', is_audio: true},
                        {id: 10, sentence: 'Ты - кровать', is_audio: false}
                    ]

cc = "insert into eng_words_users (eng_word_id, user_id, is_learned) values (4, 1, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into eng_words_users (eng_word_id, user_id, is_learned) values (5, 1, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into eng_words_users (eng_word_id, user_id, is_learned) values (9, 1, false);"
ActiveRecord::Base.connection.execute(cc)
cc = "insert into eng_words_users (eng_word_id, user_id, is_learned) values (1, 1, true);"
ActiveRecord::Base.connection.execute(cc)