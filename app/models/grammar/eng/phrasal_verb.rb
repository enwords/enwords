class Grammar::Eng::PhrasalVerb < ApplicationRecord
  validates :value, :weight, presence: true
  validates :value, uniqueness: true
end
