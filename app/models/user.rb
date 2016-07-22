class User < ActiveRecord::Base
  has_many :word_statuses, dependent: :delete_all
  has_many :words, through: :word_statuses
  has_many :sentences, through: :trainings
  has_many :books, dependent: :delete_all
  # has_one :native_language, class_name: "Language"
  # has_one :learning_language,  class_name: "Language"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :set_default_settings, if: :new_record?

  enum role: [:user, :vip, :admin]

  languages = %w(eng rus deu spa jpn cmn ara)
  enum native_language: languages, _prefix: :native
  enum learning_language: languages, _prefix: :learning

  def set_default_settings
    self.role ||= :user
    self.sentences_number ||= 5
    self.audio_enable ||= true
    self.diversity_enable ||= false
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
               self.assign_attributes(params, *options)
               self.valid?
               self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               false
             end
    clean_up_passwords
    result
  end
end