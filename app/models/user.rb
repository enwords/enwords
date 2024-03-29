class User < ApplicationRecord
  has_many :authentications, class_name: 'UserAuthentication'
  has_many :word_statuses, dependent: :delete_all
  has_many :words, through: :word_statuses
  has_many :articles, dependent: :delete_all
  has_many :grammar_eng_user_irregular_verbs, class_name: 'Grammar::Eng::UserIrregularVerb'
  has_many :grammar_eng_user_phrasal_verbs, class_name: 'Grammar::Eng::UserPhrasalVerb'
  has_many :grammar_eng_user_idioms, class_name: 'Grammar::Eng::UserIdiom'
  has_many :subscriptions
  has_many :payments

  has_one :training
  has_one :skyeng_setting
  has_one :telegram_chat

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: %i[user vip admin]
  enum native_language: Rails.configuration.languages['enums'], _prefix: :native
  enum learning_language: Rails.configuration.languages['enums'], _prefix: :learning

  store_accessor :additional_info,
                 :proficiency_levels,
                 :sign_up_params,
                 :skyeng_words_count

  after_create :create_test_article
  after_create :set_default_learning_words
  after_create :set_default_settings

  def self.testee
    find_by!(email: 'testee@qqq.qqq')
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if params[:password].blank? || valid_password?(current_password)
               update_attributes(params, *options)
             else
               assign_attributes(params, *options)
               valid?
               errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               false
             end
    clean_up_passwords
    result
  end

  def proficiency_level
    proficiency_levels.try(:[], learning_language) || 0
  end

  def set_default_learning_words
    Word::UpdateState.run(ids: [680, 833, 843, 902, 909], to_state: 'learning', user: self)
  end

  def create_test_article
    return unless Rails.env.production?

    Article.find(34).dup.update(user_id: id)
  end

  def set_default_settings
    self.proficiency_levels = {}
    proficiency_levels[learning_language] = 40
    self.sentences_number = 3
    self.audio_enable = true
    self.diversity_enable = true if learning_language == 'eng'
    save!
  end

  def premium?
    return true

    subscriptions.status_active.exists?
  end
end
