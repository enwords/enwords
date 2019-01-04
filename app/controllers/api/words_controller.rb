module Api
  class WordsController < ActionController::Base
    def generate_phrase
      render json: { resource: Word::GeneratePhrase.run! }, status: :ok
    end

    def random_sentence
      result =
        case word_text
        when /[a-z]/i then Sentence::ByWord.run!(word: word_text, language: 'eng', translation_language: 'rus')
        when /[а-ё]/i then Sentence::ByWord.run!(word: word_text, language: 'rus', translation_language: 'eng')
        end

      render json: { resource: result.as_json }, status: :ok
    end

    def mnemos
      return render json: { resource: [] }, status: :ok unless word

      _, result = Word::GetMnemo.run!(word: word)
      render json: { resource: result.as_json }, status: :ok
    end

    private

    def word
      @word ||= Word.find_by(word: word_text)
    end

    def word_text
      @word_text ||=
        params[:word].to_s.split(' ').first.mb_chars.downcase.to_s.strip
    end
  end
end
