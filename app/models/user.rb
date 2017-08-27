class User < ActiveRecord::Base
  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
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
                 :proficiency_levels

  # Allows to change a profile settings without entering a password
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
end
