require 'rails_helper'

describe Api::WordsController, type: :request do
  let(:word) { create :eng_word, word: 'obstacle' }

  let(:headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  let(:params) { {} }

  context 'GET #mnemos' do
    subject { get '/api/words/mnemos', params: params, headers: headers }

    let!(:mnemo) { create :mnemo, word: word }

    let(:params) do
      {
        word: word.word
      }
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'GET #generate_phrase' do
    subject { get '/api/words/generate_phrase', params: params, headers: headers }

    before do
      allow_any_instance_of(Word::GeneratePhrase).to receive(:run!).and_return('')
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'GET #random_sentence' do
    subject { get '/api/words/random_sentence', params: params, headers: headers }

    let(:params) do
      {
        word: word.word
      }
    end

    before do
      allow_any_instance_of(Sentence::ByWord).to receive(:run!).and_return('')
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end


# def generate_phrase
#   render json: { resource: Word::GeneratePhrase.run! }, status: :ok
# end
#
# def random_sentence
#   result =
#     case word_text
#     when /[a-z]/i then Sentence::ByWord.run!(word: word_text, language: 'eng', translation_language: 'rus')
#     when /[а-ё]/i then Sentence::ByWord.run!(word: word_text, language: 'rus', translation_language: 'eng')
#     end
#
#   render json: { resource: result.as_json }, status: :ok
# end
#
# def mnemos
#   _, result = Word::GetMnemo.run!(word: word)
#   render json: { resource: result.as_json }, status: :ok
# end