class Link < ApplicationRecord
  belongs_to :sentence,
             class_name:  'Sentence',
             foreign_key: :sentence_1_id

  belongs_to :translation,
             class_name:  'Sentence',
             foreign_key: :sentence_2_id
end
