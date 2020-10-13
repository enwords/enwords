class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :payment

  enum status: {
    pending: 1,
    active: 2,
    expired: 3,
    canceled: 4
  }, _prefix: :status

  enum plan: {
    monthly: 1,
    annual: 2
  }, _prefix: :plan

  validates :user, :payment, :plan, :status, presence: true
  validates :expires_at, presence: true, if: :status_active?
end
