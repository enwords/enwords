class User < ActiveRecord::Base
  module Languages
    SHORT_LANGUAGE_NAMES = {
      eng: 0, epo: 1, tur: 2, ita: 3, rus: 4, deu: 5, fra: 6, spa: 7, por: 8, jpn: 9, hun: 10, heb: 11, ber: 12,
      pol: 13, mkd: 14, fin: 15, nld: 16, cmn: 17,
      mar: 18, ukr: 19, swe: 20, dan: 21, srp: 22, bul: 23, ces: 24, ina: 25, lat: 26, ara: 27, nds: 28, lit: 29
    }.freeze

    FULL_LANGUAGE_NAMES = [
      %w[Arabic ara], %w[Berber ber], %w[Bulgarian bul], %w[Czech ces], %w[Chinese(mnd) cmn], %w[Danish dan],
      %w[German deu], %w[English eng], %w[Esperanto epo], %w[Finnish fin], %w[French fra], %w[Hebrew heb],
      %w[Hungarian hun], %w[Interlingua ina], %w[Italian ita], %w[Japanese jpn], %w[Latin lat], %w[Lithuanian lit],
      %w[Marathi mar], %w[Macedonian mkd], ['Low Saxon', 'nds'], %w[Dutch nld], %w[Polish pol], %w[Portuguese por],
      %w[Russian rus], %w[Spanish spa], %w[Serbian srp], %w[Swedish swe], %w[Turkish tur], %w[Ukrainian ukr]
    ].freeze
  end
end
