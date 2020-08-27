require 'rails_helper'

describe Subscriptions::ActivateWorker do
  subject { described_class.new.perform }

  let!(:subscription) { create(:subscription, status: :pending) }

  include_examples 'should present at the cron schedule'

  it 'calls Subscriptions::Activate' do
    expect(Subscriptions::Activate).to receive(:run!).with(subscription: subscription)
    subject
  end
end
