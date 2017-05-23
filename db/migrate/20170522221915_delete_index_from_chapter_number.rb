class DeleteIndexFromChapterNumber < ActiveRecord::Migration[5.0]
  def change
    remove_index :chapters, :chapter_number
  end
end
