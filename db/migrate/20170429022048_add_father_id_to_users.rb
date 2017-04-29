class AddFatherIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :father_id, :integer
  end
end
