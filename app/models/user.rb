class User < ActiveRecord::Base
  def self.create_from_omniauth(params)
    attributes = {
      email: params['info']['email'] || "#{Devise.friendly_token}@#{params['provider']}.com",
      password: Devise.friendly_token
    }

    create(attributes)
  end

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  has_many :word_statuses,
           dependent: :delete_all
  has_many :words,
           through: :word_statuses
  has_many :articles,
           dependent: :delete_all
  has_one :training

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: %i[user vip admin]

  languages = {
    eng: 0, epo: 1, tur: 2, ita: 3, rus: 4, deu: 5, fra: 6, spa: 7, por: 8, jpn: 9, hun: 10, heb: 11, ber: 12, pol: 13,
    mkd: 14, fin: 15, nld: 16, cmn: 17, mar: 18, ukr: 19, swe: 20, dan: 21, srp: 22, bul: 23, ces: 24, ina: 25, lat: 26,
    ara: 27, nds: 28, lit: 29
  }

  enum native_language: languages, _prefix: :native
  enum learning_language: languages, _prefix: :learning
  enum last_training_type: %i[training training_spelling]

  FULL_LANGUAGE_NAME =
    [
      %w[Arabic ara], %w[Berber ber], %w[Bulgarian bul], %w[Czech ces], %w[Chinese(mnd) cmn], %w[Danish dan],
      %w[German deu], %w[English eng], %w[Esperanto epo], %w[Finnish fin], %w[French fra], %w[Hebrew heb],
      %w[Hungarian hun], %w[Interlingua ina], %w[Italian ita], %w[Japanese jpn], %w[Latin lat], %w[Lithuanian lit],
      %w[Marathi mar], %w[Macedonian mkd], %w[Low Saxon nds], %w[Dutch nld], %w[Polish pol], %w[Portuguese por],
      %w[Russian rus], %w[Spanish spa], %w[Serbian srp], %w[Swedish swe], %w[Turkish tur], %w[Ukrainian ukr]
    ].freeze

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