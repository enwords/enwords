# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  def perform(*)
    user           = User.find(1)
    learning_words = Word::ByStatus.run!(status: 'learning', user: user)
    word           = learning_words.sample.word
    text           = Sentence::ByWord.run!(word: word, language: 'eng', translation_language: 'rus').text

    ActionMailer::Base.mail(
      from:    ENV['GMAIL_USERNAME'],
      to:      ENV['GMAIL_USERNAME'],
      subject: word,
      body:    text
    ).deliver

    :ok
  end
end
