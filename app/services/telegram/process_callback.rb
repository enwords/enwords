module Telegram
  class ProcessCallback < ActiveInteraction::Base
    private

    string :data
    hash :message do
      integer :message_id
      hash :chat do
        integer :id
      end
    end

    def execute
      Word::UpdateState.run!(ids: [parsed_data[:word_id]], to_state: parsed_data[:action], user: user)
      DeleteMessage.run!(chat_id: message[:chat][:id], message_id: message[:message_id])
      :ok
    end

    def parsed_data
      @parsed_data ||= JSON.parse(data).deep_symbolize_keys
    end

    def user
      @user ||= User.find(parsed_data[:user_id])
    end
  end
end
