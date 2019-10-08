require 'rails_helper'

describe Telegram::SendMessageToSubscribersWorker do
  subject { described_class.new.perform }

  include_examples 'should present at the cron schedule'

  it 'runs Telegram::SendMessagesToSubscribers' do
    expect(Telegram::SendMessageToSubscribers).to receive(:run!)
    subject
  end
end
