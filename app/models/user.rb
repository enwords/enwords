class User < ActiveRecord::Base
  has_many :word_statuses, dependent: :delete_all
  has_many :words, through: :word_statuses
  has_many :studying_words, through: :training_words, source: :word
  has_many :training_words
  has_many :studying_sentences, through: :training_sentences, source: :sentence
  has_many :training_sentences
  has_many :articles, dependent: :delete_all
  # has_one :native_language, class_name: "Language"
  # has_one :learning_language,  class_name: "Language"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :set_default_settings, if: :new_record?

  enum role: [:user, :vip, :admin]

  languages = {eng: 0, epo: 1, tur: 2, ita: 3, rus: 4, deu: 5, fra: 6, spa: 7, por: 8, jpn: 9, hun: 10, heb: 11, ber: 12,
               pol: 13, mkd: 14, fin: 15, nld: 16, cmn: 17, mar: 18, ukr: 19, swe: 20, dan: 21, srp: 22, bul: 23, ces: 24,
               ina: 25, lat: 26, ara: 27, nds: 28, lit: 29}

  enum full_languages: [["ara", "Arabic"], ["ber", "Berber"], ["bul", "Bulgarian"], ["ces", "Czech"], ["cmn", "Chinese (Mandarin)"],
                        ["dan", "Danish"], ["deu", "German"], ["eng", "English"], ["epo", "Esperanto"], ["fin", "Finnish"],
                        ["fra", "French"], ["heb", "Hebrew"], ["hun", "Hungarian"], ["ina", "Interlingua"], ["ita", "Italian"],
                        ["jpn", "Japanese"], ["lat", "Latin"], ["lit", "Lithuanian"], ["mar", "Marathi"], ["mkd", "Macedonian"],
                        ["nds", "Low Saxon"], ["nld", "Dutch"], ["pol", "Polish"], ["por", "Portuguese"], ["rus", "Russian"],
                        ["spa", "Spanish"], ["srp", "Serbian"], ["swe", "Swedish"], ["tur", "Turkish"], ["ukr", "Ukrainian"]]

  enum native_language: languages, _prefix: :native
  enum learning_language: languages, _prefix: :learning

  enum last_training: [:training, :training_spelling]

  #Set the default settings when registering a new user
  def set_default_settings
    self.role ||= :user
    self.sentences_number ||= 5
    self.audio_enable ||= true
    self.diversity_enable ||= false
    self.learned_words_count ||= 0
  end

  #Allows to change a profile settings without entering a password
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