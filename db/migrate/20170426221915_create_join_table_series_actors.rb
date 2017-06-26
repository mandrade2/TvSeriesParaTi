class CreateJoinTableSeriesActors < ActiveRecord::Migration[5.0]
  def change
    create_join_table :series, :actors do |t|
      t.index :series_id
      t.index :actor_id
    end
    add_index :actors_series, [:series_id, :actor_id], unique: true
  end
end
