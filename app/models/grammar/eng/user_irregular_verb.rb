class Grammar::Eng::UserIrregularVerb < ApplicationRecord
  belongs_to :user
  belongs_to :irregular_verb, class_name: 'Grammar::Eng::IrregularVerb'

  validates :user, :irregular_verb, presence: true
  validates :irregular_verb_id, uniqueness: { scope: :user_id }
end
