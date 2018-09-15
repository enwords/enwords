module Api
  class WordsController < ActionController::Base
    def generate_phrase
      render json: { resource: Word::GeneratePhrase.run! }, status: :ok
    end

    def random_sentence
      word = word.to_s.split(' ').first.downcase.strip

      result =
        case word
        when /[a-z]/i then Sentence::ByWord.run!(word: word, language: 'eng', translation_language: 'rus')
        when /[а-ё]/i then Sentence::ByWord.run!(word: word, language: 'rus', translation_language: 'eng')
        end

      render json: { resource: result.as_json }, status: :ok
    end
  end
end
