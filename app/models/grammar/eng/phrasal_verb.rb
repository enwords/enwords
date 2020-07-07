class Grammar::Eng::PhrasalVerb < ApplicationRecord
  has_many :meanings, class_name: 'Grammar::Eng::PhrasalVerbMeaning'
  validates :value, :weight, presence: true
  validates :value, uniqueness: true
end
