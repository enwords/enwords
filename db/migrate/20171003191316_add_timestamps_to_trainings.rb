class AddTimestampsToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :created_at, :datetime
    add_column :trainings, :updated_at, :datetime
  end
end
