class Training < ApplicationRecord
  belongs_to :user
  TRAINING_TYPES = %w[repeating spelling].freeze
  enum training_type: TRAINING_TYPES.each_with_object({}) { |e, hsh| hsh[e] = e }
end
