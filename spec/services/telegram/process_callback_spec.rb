require 'rails_helper'

describe Telegram::ProcessCallback do
  subject { described_class.run!(callback) }

  let(:callback) do
    {
      id: "689727725824529856",
      from: {
        id: 160_589_750,
        is_bot: false,
        first_name: "Dmitry",
        last_name: "Sadovnikov",
        username: "DmitrySadovnikov",
        language_code: "en"
      },
      message: {
        message_id: 204,
        from: {
          id: 669_937_716,
          is_bot: true,
          first_name: "Enwords test",
          username: "enwords_schedule_bot"
        },
        chat: {
          id: 160_589_750,
          first_name: "Dmitry",
          last_name: "Sadovnikov",
          username: "DmitrySadovnikov",
          type: "private"
        },
        date: 1_567_159_596,
        text: "lol [ɛl-əʊ-ɛl] - умираю от смеха\n\nThe vacation is over now.\nТеперь каникулы закончились.",
        entities: [
          {
            offset: 0,
            length: 3,
            type: "bold"
          },
          {
            offset: 4,
            length: 10,
            type: "italic"
          },
          {
            offset: 60,
            length: 28,
            type: "italic"
          }
        ],
        reply_markup: {
          inline_keyboard: [
            [
              {
                text: "Добавить в Выученные",
                callback_data: "{\"word_id\":1,\"action\":\"learned\"}"
              }
            ]
          ]
        }
      },
      chat_instance: "-3541412129659379789",
      data: "{\"user_id\":#{user.id},\"word_id\":#{word.id},\"action\":\"learned\"}"
    }
  end

  let(:word) { create(:word) }
  let(:user) { create(:user) }

  before do
    stub_request(:post, /deleteMessage/)
      .with(body: "chat_id=160589750&message_id=204")
      .to_return(status: 200, body: "{}", headers: {})
  end

  it 'returns ok' do
    expect(subject).to eq(:ok)
  end

  it 'creates WordStatus' do
    expect { subject }.to change { WordStatus.count }.by(1)
  end
end
