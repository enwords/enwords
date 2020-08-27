require 'rails_helper'

describe Subscriptions::Create do
  subject { described_class.run!(options) }

  let(:options) do
    {
      user: user,
      plan: 'yearly'
    }
  end
  let(:user) { create(:user) }
  let(:payment) do
    create(:payment,
           status: :pending,
           user: user,
           data: [{ 'confirmation' => { 'confirmation_url' => FFaker::Internet.http_url } }])
  end

  before { allow(Yandex::Kassa::CreatePayment).to receive(:run!).and_return(payment) }

  it 'creates Subscription' do
    expect { subject }.to change { Subscription.count }.by(1)
  end
end
