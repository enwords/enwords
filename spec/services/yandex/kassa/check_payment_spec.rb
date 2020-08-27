require 'rails_helper'

describe Yandex::Kassa::CheckPayment do
  subject { described_class.run!(options) }

  let(:options) do
    {
      payment: payment
    }
  end
  let(:payment) { create(:payment, status: :pending) }
  let(:response_body) do
    {
      id: '23d93cac-000f-5000-8000-126628f15141',
      status: 'succeeded',
      paid: false,
      amount: {
        value: '100.00',
        currency: 'RUB'
      },
      confirmation: {
        type: 'redirect',
        confirmation_url: 'https://money.yandex.ru'
      },
      created_at: '2019-01-22T14:30:45.129Z',
      description: 'Заказ №1',
      metadata: {},
      recipient: {
        account_id: '100001',
        gateway_id: '1000001'
      },
      refundable: false,
      test: false
    }
  end

  before do
    stub_request(:get, "https://payment.yandex.net/api/v3/payments/#{payment.id}")
      .to_return(status: 200, body: response_body.to_json, headers: {})
  end

  it 'changes payment status' do
    expect { subject }.to change { payment.reload.status }.to('succeeded')
  end
end
