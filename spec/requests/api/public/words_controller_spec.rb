require 'rails_helper'

describe Api::Public::WordsController, type: :request do
  let(:word) { create :eng_word, value: 'obstacle' }

  let(:headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  let(:params) { {} }

  context 'GET #mnemos' do
    subject { get '/api/public/words/mnemos', params: params, headers: headers }

    let!(:mnemo) { create :mnemo, word: word }

    let(:params) do
      {
        word: word.value
      }
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'GET #generate_phrase' do
    subject { get '/api/public/words/generate_phrase', params: params, headers: headers }

    before do
      create(:word, pos: :j, language: :eng)
      create(:word, pos: :i, language: :eng)
      create(:word, pos: :n, language: :eng)
      allow_any_instance_of(Word::GeneratePhrase).to receive(:run!).and_return('')
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'GET #random_sentence' do
    subject { get '/api/public/words/random_sentence', params: params, headers: headers }

    let(:params) do
      {
        word: word.value
      }
    end

    before do
      create(:word, pos: :j, language: :eng)
      create(:word, pos: :i, language: :eng)
      allow_any_instance_of(Sentence::ByWord).to receive(:run!).and_return('')
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
