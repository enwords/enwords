class Link < ApplicationRecord
  belongs_to :sentence_1, class_name: 'Sentence'
  belongs_to :sentence_2, class_name: 'Sentence'
end
