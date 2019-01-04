require 'rails_helper'

xdescribe Api::Telegram::ScheduleBotsController do
  context 'message' do
    before do
      allow(Telegram::ScheduleBot::Reply).to receive(:run!).and_return(true)
    end

    it do
      get :message, params: {
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
            'text'       => 'привет'
          }
      }
      expect(response.code).to eql '200'
    end
  end
end
