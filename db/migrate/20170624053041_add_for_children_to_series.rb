class AddForChildrenToSeries < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :for_children, :boolean
  end
end
