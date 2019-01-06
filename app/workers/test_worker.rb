# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  def perform(*)
    user           = User.find(1)
    learning_words = Word::ByStatus.run!(status: 'learning', user: user)
    word           = learning_words.sample.value
    translation    = skyeng_translation(word)
    return :no_translation unless translation

    text = Sentence::ByWord.run!(word: word, language: 'eng', translation_language: 'rus').text

    ActionMailer::Base.mail(
      from:    ENV['GMAIL_USERNAME'],
      to:      ENV['GMAIL_USERNAME'],
      subject: word + ' - ' + translation,
      body:    text
    ).deliver

    :ok
  end

  def skyeng_translation(word)
    Api::Skyeng.first_meaning(word: word).dig('translation', 'text') rescue nil
  end
end
