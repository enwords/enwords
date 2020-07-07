class Grammar::Eng::PhrasalVerbMeaning < ApplicationRecord
  belongs_to :phrasal_verb, class_name: 'Grammar::Eng::PhrasalVerb'
  validates :value, presence: true
end
