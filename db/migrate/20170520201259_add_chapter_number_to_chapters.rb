class AddChapterNumberToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :chapter_number, :integer
    add_index :chapters, :chapter_number, unique: true
  end
end
