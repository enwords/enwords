require 'rails_helper'

describe WordsController, type: :request do
  context 'GET words' do
    subject { get '/en/words', params: params }

    let(:user) { create :user }
    let!(:word) { create :eng_word }
    let(:params) do
      {
        status: 'unknown',
        locale: 'ru'
      }
    end

    before { login_as(user, scope: :user) }

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
