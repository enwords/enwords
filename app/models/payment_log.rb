class PaymentLog < ApplicationRecord
  enum payment_type: {
    subscription: 1
  }, _prefix: :payment_type

  enum provider: {
    paypal: 1
  }, _prefix: :provider

  validates :payment_type, :provider, presence: true
end
