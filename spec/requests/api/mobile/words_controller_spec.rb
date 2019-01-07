require 'rails_helper'

describe Api::Mobile::WordsController, type: :request do
  let(:user) { create :user }
  let(:word) { create :eng_word, value: 'obstacle' }
  let!(:word_status) do
    create :word_status, word: word, user: user, learned: false
  end

  let(:headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  let(:params) { {} }

  context 'GET' do
    subject { get '/api/mobile/words', params: params, headers: headers }

    let(:params) do
      {
        status: 'learning'
      }
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
