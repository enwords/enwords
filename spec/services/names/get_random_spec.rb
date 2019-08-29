require 'rails_helper'

describe Names::GetRandom do
  subject { described_class.run! }

  before do
    create(:word, pos: :j, language: :eng)
    create(:word, pos: :i, language: :eng)
    create(:word, pos: :n, language: :eng)
  end

  it 'returns hash' do
    expect(subject).to be_a(Hash)
    expect(subject[:group]).to be_a(String)
    expect(subject[:name]).to be_a(String)
  end
end
