require 'rails_helper'

describe Payments::Paypal::Requests::GetAccessToken do
  subject { described_class.run!(word: word, translation_lang: translation_lang) }

  let(:access_token) { SecureRandom.uuid }

  before do
    stub_paypal_access_token_request(access_token)
    Rails.cache.delete_matched(/paypal_access_token_hash(.*)/)
  end

  it 'makes request' do
    expect(Curl).to receive(:post).and_call_original
    subject
  end
  it 'returns token' do
    expect(subject).to eq(access_token)
  end
  it 'writes to cache' do
    subject
    expect(Rails.cache.read("paypal_access_token_#{paypal_cred.id}")['access_token']).to eq(access_token)
  end
end
