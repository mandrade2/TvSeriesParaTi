class CreateJoinTableUsersComments < ActiveRecord::Migration[5.0]
  def change
    create_join_table :comments, :users do |t|
      t.references :user
      t.references :comment
    end
    add_index :comments_users, [:comment_id, :user_id], unique: true
  end
end
