class CreateJoinTableUsersChapters < ActiveRecord::Migration[5.0]
  def change
    create_join_table :chapters, :users do |t|
      t.index :chapter_id
      t.index :user_id
    end
    add_index :chapters_users, [:chapter_id, :user_id], unique: true
  end
end
