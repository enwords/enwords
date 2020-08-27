require 'rails_helper'

describe API::Web::PaymentsController do
  describe '#callback' do
    subject { post '/api/web/payments/callback', headers: headers, params: params.to_json }

    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:params) { { FFaker::Lorem.word => FFaker::Lorem.word } }

    it 'returns 200' do
      expect(subject).to eq(200)
    end
    it 'creates PaymentCallback' do
      expect { subject }.to change { PaymentCallback.count }.by(1)
    end
  end
end
