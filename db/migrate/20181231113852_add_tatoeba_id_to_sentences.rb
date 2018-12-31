class AddTatoebaIdToSentences < ActiveRecord::Migration[5.0]
  def change
    add_column :sentences, :tatoeba_id, :integer
    add_column :sentences, :with_audio, :boolean, default: false

    Sentence.update_all('tatoeba_id = id')
    Sentence.where(id: Audio.select(:sentence_id)).update_all(with_audio: true)
  end
end
