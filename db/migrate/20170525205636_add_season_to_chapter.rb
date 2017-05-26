class AddSeasonToChapter < ActiveRecord::Migration[5.0]
  def change
    remove_reference :chapters, :series, index: true, foreign_key: true
    remove_reference :chapters, :user, index: true, foreign_key: true
    add_reference :chapters, :season, foreign_key: true
    add_index :chapters, %i[season_id chapter_number], unique: true
  end
end
