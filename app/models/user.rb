class User < ActiveRecord::Base
  has_many :word_statuses, dependent: :delete_all
  has_many :words, through: :word_statuses
  has_many :studying_words, through: :training_words, source: :word
  has_many :training_words
  has_many :studying_sentences, through: :training_sentences, source: :sentence
  has_many :training_sentences
  has_many :articles, dependent: :delete_all
  # has_one :native_language, class_name: Language
  # has_one :learning_language,  class_name: Language

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: %i[user vip admin]

  languages = { eng: 0, epo: 1, tur: 2, ita: 3, rus: 4, deu: 5, fra: 6, spa: 7, por: 8, jpn: 9, hun: 10, heb: 11, ber: 12,
                pol: 13, mkd: 14, fin: 15, nld: 16, cmn: 17, mar: 18, ukr: 19, swe: 20, dan: 21, srp: 22, bul: 23, ces: 24,
                ina: 25, lat: 26, ara: 27, nds: 28, lit: 29 }

  enum full_languages:
         [
           %w[ara Arabic], %w[ber Berber], %w[bul Bulgarian], %w[ces Czech], %w[cmn Chinese(mnd)], %w[dan Danish],
           %w[deu German], %w[eng English], %w[epo Esperanto], %w[fin Finnish], %w[fra French], %w[heb Hebrew],
           %w[hun Hungarian], %w[ina Interlingua], %w[ita Italian], %w[jpn Japanese], %w[lat Latin], %w[lit Lithuanian],
           %w[mar Marathi], %w[mkd Macedonian], %w[nds Low Saxon], %w[nld Dutch], %w[pol Polish], %w[por Portuguese],
           %w[rus Russian], %w[spa Spanish], %w[srp Serbian], %w[swe Swedish], %w[tur Turkish], %w[ukr Ukrainian]
         ]

  enum native_language: languages, _prefix: :native
  enum learning_language: languages, _prefix: :learning
  enum last_training_type: %i[training training_spelling]

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
end