class TestWorker
  include Sidekiq::Worker

  def perform(*)
    user = User.find(1)
    learning_words = Word::ByStatus.run!(status: 'learning', user: user)
    word = learning_words.sample
    return :no_word unless word

    result = Sentence::ByWord.run!(word: word, trans_lang: 'rus')
    result = result[:text]
    return :no_word_translation if word_translation.blank?

    Telegram::SendMessage.run!(text: result[:text], chat_id: 160_589_750)
    :ok
  end
end
