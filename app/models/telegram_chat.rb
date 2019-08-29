class TelegramChat < ApplicationRecord
  belongs_to :user
  validates :chat_id, :username, presence: true
end
