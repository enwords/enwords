require 'rails_helper'

describe Subscriptions::Activate do
  subject { described_class.run!(subscription: subscription) }

  let(:user) { create(:user) }
  let(:payment) { create(:payment, user: user, status: payment_status) }
  let(:subscription) { create(:subscription, user: user, payment: payment, status: :pending) }
  let(:payment_status) { :succeeded }

  before do
    allow(Yandex::Kassa::CheckPayment).to receive(:run!).and_return(payment)
  end

  it 'changes subscription status' do
    expect { subject }.to change { subscription.reload.status }.to('active')
  end

  context 'with canceled payment' do
    let(:payment_status) { :canceled }

    it 'changes subscription status' do
      expect { subject }.to change { subscription.reload.status }.to('canceled')
    end
  end

  context 'with pending payment' do
    let(:payment_status) { :pending }

    it 'does not change subscription status' do
      expect { subject }.not_to change { subscription.reload.status }
    end
  end
end
