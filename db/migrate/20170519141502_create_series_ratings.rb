class CreateSeriesRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :series_ratings do |t|
      t.integer :rating
      t.references :user, foreign_key: true
      t.references :series, foreign_key: true

      t.timestamps
    end
  end
end
