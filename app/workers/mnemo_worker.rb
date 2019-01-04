# frozen_string_literal: true

class MnemoWorker
  include Sidekiq::Worker

  def perform(*)
    word = Word.where(language: 'eng').where.not(id: Mnemo.select(:word_id)).first
    return :no_word unless word

    Word::GetMnemo.run!(word: word)
    :ok
  end
end
