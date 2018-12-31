class AddIdToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links,           :id, :uuid, default: 'uuid_generate_v4()', null: false, primary_key: true
    add_column :sentences_words, :id, :uuid, default: 'uuid_generate_v4()', null: false, primary_key: true
    add_column :word_statuses,   :id, :uuid, default: 'uuid_generate_v4()', null: false, primary_key: true
  end
end
