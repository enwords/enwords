require 'rails_helper'

describe WordsController do
  context 'success' do
    let(:user) { create :user }
    let!(:word) { create :eng_word }

    subject { described_class }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:authenticate_user!).and_return(true)

      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(request.env['warden'])
        .to receive(:authenticate!).and_throw(:warden, scope: :user)
    end

    it 'index' do
      get :index, params: { status: 'unknown', locale: 'ru' }
      expect(response.code).to eql '200'
    end
  end
end
