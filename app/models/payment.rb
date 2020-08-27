class Payment < ApplicationRecord
  belongs_to :user

  enum status: {
    pending: 1,
    succeeded: 2,
    canceled: 3,
    waiting_for_capture: 4
  }, _prefix: :status

  enum provider: {
    yandex: 1
  }, _prefix: :provider

  validates :user, :amount_cents, :currency, :provider, :status, presence: true
end
