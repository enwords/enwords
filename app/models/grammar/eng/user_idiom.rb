class Grammar::Eng::UserIdiom < ApplicationRecord
  belongs_to :user
  belongs_to :idiom, class_name: 'Grammar::Eng::Idiom'

  validates :user, :idiom, presence: true
  validates :idiom_id, uniqueness: { scope: :user_id }
end
