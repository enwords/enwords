class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.references :user, foreign_key: true
      t.string :language
      t.text :content
      t.string :title

      t.timestamps
    end
  end
end
