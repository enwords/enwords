require 'rails_helper'

describe Api::Mobile::TrainingsController, type: :request do
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

  context '#create' do
    subject do
      post '/api/mobile/trainings', params: params.to_json, headers: headers
    end

    before do
      create(:user, email: 'testee@qqq.qqq')
    end

    let(:params) do
      {
        word_ids:      [word.id],
        training_type: 'repeating'
      }
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'creates training' do
      expect { subject }.to change(Training, :count).by(1)
    end
  end
end
