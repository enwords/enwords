require 'rails_helper'

describe Api::Telegram::MessagesController, type: :request do
  context 'message' do
    subject do
      post '/api/telegram/messages', params: params.to_json, headers: headers
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
        'update_id' => 394_352_518,
        'message' =>
          {
            'message_id' => 5,
            'from' =>
              {
                'id' => 160_589_750,
                'is_bot' => false,
                'first_name' => 'Dmitry',
                'last_name' => 'Sadovnikov',
                'username' => 'DmitrySadovnikov',
                'language_code' => 'en-RU'
              },
            'chat' =>
              {
                'id' => 160_589_750,
                'first_name' => 'Dmitry',
                'last_name' => 'Sadovnikov',
                'username' => 'DmitrySadovnikov',
                'type' => 'private'
              },
            'date' => 1_527_367_962,
            'text' => word.value
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

    context 'with callback' do
      let(:user) { create(:user) }
      let(:word) { create(:word) }

      let(:params) do
        {
          update_id: 132_359_233,
          callback_query: {
            id: "689727727951515987",
            from: {
              id: 160_589_750,
              is_bot: false,
              first_name: "Dmitry",
              last_name: "Sadovnikov",
              username: "DmitrySadovnikov",
              language_code: "en"
            },
            message: {
              message_id: 54,
              from: {
                id: 892_276_454,
                is_bot: true,
                first_name: "Enwords",
                username: "enwordsapp_bot"
              },
              chat: {
                id: 160_589_750,
                first_name: "Dmitry",
                last_name: "Sadovnikov",
                username: "DmitrySadovnikov",
                type: "private"
              },
              date: 1_567_163_062,
              text: "escaped [ɪsˈkeɪpt] - сбежавший\n\nA tiger has escaped from the zoo.\nИз зоопарка сбежал тигр.",
              entities: [
                {
                  offset: 0,
                  length: 7,
                  type: "bold"
                },
                {
                  offset: 8,
                  length: 10,
                  type: "italic"
                },
                {
                  offset: 66,
                  length: 24,
                  type: "italic"
                }
              ],
              reply_markup: {
                inline_keyboard: [
                  [
                    {
                      text: "Добавить в Выученные",
                      callback_data: "{\"user_id\":#{user.id},\"word_id\":#{word.id},\"action\":\"learned\"}"
                    }
                  ]
                ]
              }
            },
            chat_instance: "3254013575179478708",
            data: "{\"user_id\":#{user.id},\"word_id\":#{word.id},\"action\":\"learned\"}"
          },
          controller: "api/telegram/messages",
          action: "create",
          message: {
            update_id: 132_359_233,
            callback_query: {
              id: "689727727951515987",
              from: {
                id: 160_589_750,
                is_bot: false,
                first_name: "Dmitry",
                last_name: "Sadovnikov",
                username: "DmitrySadovnikov",
                language_code: "en"
              },
              message: {
                message_id: 54,
                from: {
                  id: 892_276_454,
                  is_bot: true,
                  first_name: "Enwords",
                  username: "enwordsapp_bot"
                },
                chat: {
                  id: 160_589_750,
                  first_name: "Dmitry",
                  last_name: "Sadovnikov",
                  username: "DmitrySadovnikov",
                  type: "private"
                },
                date: 1_567_163_062,
                text: "escaped [ɪsˈkeɪpt] - сбежавший\n\nA tiger has escaped from the zoo.\nИз зоопарка сбежал тигр.",
                entities: [
                  {
                    offset: 0,
                    length: 7,
                    type: "bold"
                  },
                  {
                    offset: 8,
                    length: 10,
                    type: "italic"
                  },
                  {
                    offset: 66,
                    length: 24,
                    type: "italic"
                  }
                ],
                reply_markup: {
                  inline_keyboard: [
                    [
                      {
                        text: "Добавить в Выученные",
                        callback_data: "{\"user_id\":#{user.id},\"word_id\":#{word.id},\"action\":\"learned\"}"
                      }
                    ]
                  ]
                }
              },
              chat_instance: "3254013575179478708",
              data: "{\"user_id\":#{user.id},\"word_id\":#{word.id},\"action\":\"learned\"}"
            }
          }
        }
      end

      before do
        stub_request(:post, /deleteMessage/)
          .with(body: "chat_id=160589750&message_id=54")
          .to_return(status: 200, body: "{}", headers: {})
      end

      it do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'creates WordStatus' do
        expect { Sidekiq::Testing.inline! { subject } }.to change { WordStatus.count }.by(1)
      end
    end
  end
end
