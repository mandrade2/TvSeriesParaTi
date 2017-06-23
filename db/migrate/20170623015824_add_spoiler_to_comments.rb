class AddSpoilerToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :spoiler, :boolean, default: false
  end
end
