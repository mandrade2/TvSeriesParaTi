class AddDescriptionToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :description, :string
  end
end
