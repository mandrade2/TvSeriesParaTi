class CreateJoinTableSeriesDirectors < ActiveRecord::Migration[5.0]
  def change
  	create_join_table :series, :directors do |t|
  	  t.index :series_id
  	  t.index :director_id
	  end
    add_index :directors_series, [:series_id, :director_id], unique: true
  end
end
