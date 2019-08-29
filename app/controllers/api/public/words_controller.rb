module Api
  module Public
    class WordsController < ::Api::BaseController
      def generate_phrase
        render json: { resource: Word::GeneratePhrase.run! }, status: :ok
      end

      def random_sentence
        result = Sentence::ByWord.run!(word: word, trans_lang: trans_lang)
        render json: { resource: result }, status: :ok
      end

      def mnemos
        return render json: { collection: [] }, status: :ok unless word

        _, result = Word::GetMnemo.run!(word: word)
        render json: { collection: result.as_json }, status: :ok
      end

      private

      def word
        @word ||= Word.find_by(value: word_value, language: word_lang)
      end

      def word_lang
        @word_lang ||=
          case word_value
          when /[a-z]/i then 'eng'
          when /[а-ё]/i then 'runs'
          end
      end

      def trans_lang
        @translation_language ||=
          case word_lang
          when 'eng' then 'rus'
          when 'rus' then 'eng'
          end
      end

      def word_value
        @word_value ||=
          params[:word].to_s.split(' ').first.mb_chars.downcase.to_s.strip
      end
    end
  end
end
