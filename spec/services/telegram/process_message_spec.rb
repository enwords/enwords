require 'rails_helper'

describe Telegram::ProcessMessage do
  subject { described_class.run!(params) }

  let(:language) { 'rus' }
  let(:trans_language) { 'eng' }
  let(:word) do
    create(
      :word,
      language: language,
      value: 'хорошо',
      transcription: SecureRandom.uuid,
      data: {
        trans: { trans_language => 'good' }
      }
    )
  end
  let(:sentence) { create :sentence, value: 'word word word', language: language }
  let!(:sentences_word) { create :sentences_word, sentence: sentence, word: word }
  let(:translation) { create :sentence, language: trans_language }
  let!(:link) { create :link, sentence: sentence, translation: translation }
  let(:chat) { create(:telegram_chat) }
  let(:params) do
    {
      'chat' => {
        'id' => chat.chat_id,
        'type' => 'private',
        'last_name' => 'last_name',
        'first_name' => 'first_name'
      },
      'date' => 1,
      'from' => {
        'id' => chat.chat_id,
        'is_bot' => false,
        'last_name' => 'last_name',
        'first_name' => 'first_name',
        'language_code' => 'ru'
      },
      'text' => word.value,
      'message_id' => 1
    }
  end

  before do
    stub_request(:post, /sendMessage/).to_return(status: 200, body: {}.to_json, headers: {})
  end

  it 'sends reply' do
    expect(subject).to eq({})
  end
end
