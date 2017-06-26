class CreateJoinTableSeriesGenders < ActiveRecord::Migration[5.0]
  def change
    create_join_table :series, :genders do |t|
      t.index :series_id
      t.index :gender_id
    end
    add_index :genders_series, [:series_id, :gender_id], unique: true
  end
end
