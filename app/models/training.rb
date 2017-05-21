class Training < ApplicationRecord
  belongs_to :user
  TRAINING_TYPES = %w[repeating spelling].freeze
end
