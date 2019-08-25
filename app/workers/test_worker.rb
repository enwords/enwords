class TestWorker
  include Sidekiq::Worker

  def perform(*)
    user = User.find(1)
    learning_words = Word::ByStatus.run!(status: 'learning', user: user)
    word = learning_words.sample
    return :no_word unless word

    sentence_struct = Sentence::ByWord.run!(word: word, trans_lang: 'rus')
    word_translation = sentence_struct.text
    return :no_word_translation unless word_translation

    Telegram::ScheduleBot::Reply.run!(text: sentence_struct.text, chat_id: 160_589_750)
    :ok
  end
end
