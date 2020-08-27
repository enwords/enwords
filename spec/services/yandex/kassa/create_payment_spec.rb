require 'rails_helper'

describe Yandex::Kassa::CreatePayment do
  subject { described_class.run!(options) }

  let(:options) do
    {
      user: user,
      amount_cents: amount_cents,
      currency: currency
    }
  end
  let(:user) { create(:user) }
  let(:amount_cents) { rand(1_00..100_00) }
  let(:currency) { 'RUB' }
  let(:response_body) do
    {
      id: '22e18a2f-000f-5000-a000-1db6312b7767',
      status: 'succeeded',
      paid: true,
      amount: {
        value: '2.00',
        currency: 'RUB'
      },
      authorization_details: {
        rrn: '10000000000',
        auth_code: '000000'
      },
      captured_at: '2018-07-18T17:20:50.825Z',
      created_at: '2018-07-18T17:18:39.345Z',
      description: 'Заказ №72',
      metadata: {},
      payment_method: {
        type: 'bank_card',
        id: '22e18a2f-000f-5000-a000-1db6312b7767',
        saved: true,
        card: {
          first6: '555555',
          last4: '4444',
          expiry_month: '07',
          expiry_year: '2022',
          card_type: 'MasterCard',
          issuer_country: 'RU',
          issuer_name: 'Sberbank'
        },
        title: 'Bank card *4444'
      },
      refundable: true,
      refunded_amount: {
        value: '0.00',
        currency: 'RUB'
      },
      recipient: {
        account_id: '100001',
        gateway_id: '1000001'
      },
      test: false
    }
  end

  before do
    stub_request(:post, 'https://payment.yandex.net/api/v3/payments')
      .to_return(status: 200, body: response_body.to_json, headers: {})
  end

  it 'creates Payment' do
    expect { subject }.to change { Payment.count }.by(1)
  end
end
