class User < ActiveRecord::Base
  has_many :word_statuses, dependent: :delete_all
  has_many :words, through: :word_statuses
  has_many :trainings
  has_many :sentences, through: :trainings
  has_many :collections
  # has_one :native_language, class_name: "Language"
  # has_one :learning_language,  class_name: "Language"

  enum role: [:user, :vip, :admin]

  lang = [:eng, :rus, :jpn]
  enum native_language: lang, _prefix: :native
  enum learning_language: lang, _prefix: :learning

  after_initialize :set_default_settings, if: :new_record?

  def set_default_settings
    self.role ||= :user
    self.native_language ||= :rus#rus
    self.learning_language ||= :eng#eng
    self.sentences_number ||= 5
    self.audio_enable ||= true
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


end