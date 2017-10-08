class SkyengSetting < ApplicationRecord
  belongs_to :user

  include AASM

  aasm do
    state :token_adding, initial: true
    state :email_adding
    state :finished

    event :add_token do
      transitions from: :email_adding, to: :token_adding
    end

    event :finish do
      transitions from: :token_adding, to: :finished
    end

    event :add_email do
      transitions from: :finished, to: :email_adding
    end
  end
end
