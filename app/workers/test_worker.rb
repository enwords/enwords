# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  def perform(*)
    user           = User.find(1)
    learning_words = Word::ByStatus.run!(status: 'learning', user: user)
    word           = learning_words.sample
    word_value     = word.value
    translation    = skyeng_translation(word_value)
    return :no_translation unless translation

    text = Sentence::ByWord.run!(word: word, trans_lang: 'rus').text

    ActionMailer::Base.mail(
      from:    ENV['GMAIL_USERNAME'],
      to:      ENV['GMAIL_USERNAME'],
      subject: word_value + ' - ' + translation,
      body:    text
    ).deliver

    :ok
  end

  def skyeng_translation(word_value)
    Api::Skyeng.first_meaning(word: word_value).dig('translation', 'text') rescue nil
  end
end
