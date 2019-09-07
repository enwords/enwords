class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.references :user, foreign_key: true
      t.string :language, limit: 4
      t.string :content, limit: 100_000
      t.string :title, limit: 100

      t.timestamps
    end
  end
end
