require 'rails_helper'

describe Telegram::SendMessageToSubscribers do
  subject { described_class.run! }

  let(:user) { create(:user) }
  let!(:telegram_chat) { create(:telegram_chat, user: user, active: true) }
  let!(:word_status) { create(:word_status, user: user, learned: true) }

  before do
    allow(Word::ByStatus).to receive(:run!).and_return([word_status.word])
    allow(Sentence::ByWord).to receive(:run!).and_return(text: SecureRandom.uuid)
    stub_request(:post, /telegram/).to_return(status: 200, body: { ok: true }.to_json, headers: {})
  end

  it 'returns ok' do
    expect(subject).to eq(:ok)
  end
end
