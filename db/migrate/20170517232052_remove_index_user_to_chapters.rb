class RemoveIndexUserToChapters < ActiveRecord::Migration[5.0]
  def change
    remove_index :chapters, :user_id
  end
end
