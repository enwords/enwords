require 'rails_helper'

describe API::Payments::WebhooksController do
  describe 'paypal' do
    subject { post '/api/payments/webhooks/paypal', params: params }

    let(:params) { { test: FFaker::Lorem.word } }

    it 'returns 200' do
      subject
      expect(response).to have_http_status(:success)
    end
    it 'creates PaymentLog' do
      expect { subject }.to change { PaymentLog.count }.by(1)
    end
  end
end
