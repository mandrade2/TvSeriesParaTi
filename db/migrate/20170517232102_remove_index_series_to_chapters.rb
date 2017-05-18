class RemoveIndexSeriesToChapters < ActiveRecord::Migration[5.0]
  def change
    remove_index :chapters, :series_id
  end
end
