class AddIndexSeriesUserToChapters < ActiveRecord::Migration[5.0]
  def change
    add_index :chapters, %i[series_id name], unique: true
  end
end
