class CreateSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :series do |t|
      t.string :name
      t.string :description
      t.string :country
      t.integer :seasons
      t.integer :chapters_duration
      t.float :rating

      t.timestamps
    end
  end
end
