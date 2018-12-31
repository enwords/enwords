class AddTatoebaIdToSentences < ActiveRecord::Migration[5.0]
  def change
    add_column :sentences, :tatoeba_id, :integer
    add_column :sentences, :with_audio, :boolean, default: false

    Sentence.update_all('tatoeba_id = id')
  end
end
