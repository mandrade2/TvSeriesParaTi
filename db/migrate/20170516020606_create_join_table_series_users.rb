class CreateJoinTableSeriesUsers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :series, :users do |t|
      t.index :series_id
      t.index :user_id
    end
    add_index :series_users, [:series_id, :user_id], unique: true
  end
end
