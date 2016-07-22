class Wordbook < ApplicationRecord
  belongs_to :book
  belongs_to :word
end
