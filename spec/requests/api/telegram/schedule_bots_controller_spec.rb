require 'rails_helper'

describe Api::Telegram::ScheduleBotsController, type: :request do
  context 'message' do
    subject do
      post '/api/telegram/schedule_bots/message',
           params:  params.to_json,
           headers: headers
    end

    let(:word) { create :word, word: 'привет', language: 'rus' }
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
            'text'       => word.word
          }
      }
    end

    before do
      allow(Telegram::ScheduleBot::Reply).to receive(:run!).and_return(true)
    end

    it do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
