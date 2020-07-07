class Grammar::Eng::UserPhrasalVerb < ApplicationRecord
  belongs_to :user
  belongs_to :phrasal_verb, class_name: 'Grammar::Eng::PhrasalVerb'

  validates :user, :phrasal_verb, presence: true
  validates :phrasal_verb_id, uniqueness: { scope: :user_id }
end
