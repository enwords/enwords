class Message < ApplicationRecord
  enum message_type: {
    message: 1,
    callback_query: 2
  }, _prefix: :message_type
end
