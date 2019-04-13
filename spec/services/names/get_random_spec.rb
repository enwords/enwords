require 'rails_helper'

describe Names::GetRandom do
  subject { described_class.run! }

  it 'returns hash' do
    expect(subject).to be_a(Hash)
    expect(subject[:group]).to be_a(String)
    expect(subject[:name]).to be_a(String)
  end
end
