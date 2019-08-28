module Telegram
  class GetUpdates < BaseRequest
    def execute
      response = response('getUpdates', offset: Rails.cache.read('telegram_update_id'))
      update_id = response.dig(:result, -1, :update_id)
      Rails.cache.write('telegram_update_id', update_id.next) if update_id
      response
    end
  end
end
