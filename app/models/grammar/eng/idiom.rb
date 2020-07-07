class Grammar::Eng::Idiom < ApplicationRecord
  validates :value, :meaning, :weight, presence: true
  validates :value, uniqueness: true
end
