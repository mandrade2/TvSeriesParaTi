class ChangeDurationToInt < ActiveRecord::Migration[5.0]
  def change
    remove_column :chapters, :duration, :string
    add_column :chapters, :duration, :integer
  end
end
