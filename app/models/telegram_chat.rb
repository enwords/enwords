class TelegramChat < ApplicationRecord
  belongs_to :user
  validates :chat_id, presence: true
end
