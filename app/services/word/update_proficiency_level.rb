# coding: utf-8

class Word::UpdateProficiencyLevel < ActiveInteraction::Base
  object  :user
  integer :limit

  def execute
    user.proficiency_levels = {} unless user.proficiency_levels
    user.proficiency_levels[user.learning_language] = limit
    user.save
  end
end