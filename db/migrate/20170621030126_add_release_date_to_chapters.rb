class AddReleaseDateToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :release_date, :date
  end
end
