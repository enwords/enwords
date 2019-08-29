class User < ApplicationRecord
  has_many :authentications,
    class_name: 'UserAuthentication'

  has_many :word_statuses,
    dependent: :delete_all

  has_many :words,
    through: :word_statuses

  has_many :articles,
    dependent: :delete_all

  has_one :training

  has_one :skyeng_setting

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include User::Languages

  enum role: %i[user vip admin]
  enum native_language: SHORT_LANGUAGE_NAMES, _prefix: :native
  enum learning_language: SHORT_LANGUAGE_NAMES, _prefix: :learning

  store_accessor :additional_info,
    :proficiency_levels,
    :sign_up_params,
    :skyeng_words_count

  after_create :create_test_article
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

  def create_test_article
    return unless Rails.env.production?
    Article.find(34).dup.update(user_id: id)
  end

  def set_default_settings
    self.proficiency_levels = {}
    self.proficiency_levels[learning_language] = 100
    self.sentences_number = 3
    save!
  end
end
