class AddTranscriptionToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :transcription, :string
  end
end
