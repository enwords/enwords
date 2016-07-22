class WordInArticle < ApplicationRecord
  belongs_to :article
  belongs_to :word
end
