require 'rails_helper'

describe Api::Telegram::MessagesController, type: :request do
  context 'message' do
    subject do
      post '/api/telegram/messages',
           params:  params.to_json,
           headers: headers
    end

    let(:word) { create :word, value: 'привет', language: 'rus' }
    let(:sentence) { create :sentence, language: 'rus' }
    let(:translation) { create :sentence, language: 'eng' }
    let!(:sentences_word) { create :sentences_word, word: word, sentence: sentence }
    let!(:link) { create :link, sentence: sentence, translation: translation }

    let(:headers) do
      {
        'Content-Type' => 'application/json'
      }
    end

    let(:params) do
      {
        'update_id' => 394352518,
        'message'   =>
          {
            'message_id' => 5,
            'from'       =>
              {
                'id'            => 160589750,
                'is_bot'        => false,
                'first_name'    => 'Dmitry',
                'last_name'     => 'Sadovnikov',
                'username'      => 'DmitrySadovnikov',
                'language_code' => 'en-RU'
              },
            'chat'       =>
              {
                'id'         => 160589750,
                'first_name' => 'Dmitry',
                'last_name'  => 'Sadovnikov',
                'username'   => 'DmitrySadovnikov',
                'type'       => 'private'
              },
            'date'       => 1527367962,
            'text'       => word.value
          }
      }
    end

    before do
      allow(Telegram::SendMessage).to receive(:run!).and_return(true)
      allow(Api::Skyeng).to receive(:first_meaning).and_return(
        'id' => 92_160,
        'partOfSpeechCode' => 'n',
        'translation' => { 'text' => 'слово', 'note' => nil },
        'previewUrl' => '//static.skyeng.ru/image/download/project/dictionary/id/119873/width/96/height/72',
        'imageUrl' => '//static.skyeng.ru/image/download/project/dictionary/id/119873/width/640/height/480',
        'transcription' => 'wɜːd',
        'soundUrl' => '//dmsbj0x9fxpml.cloudfront.net/0795f8750310b61cf71bb9ff6fdc1d40.mp3',
        'text' => 'word'
      )
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
