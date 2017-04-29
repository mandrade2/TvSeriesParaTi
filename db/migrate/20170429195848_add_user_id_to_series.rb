class AddUserIdToSeries < ActiveRecord::Migration[5.0]
  def change
    add_reference :series, :user, foreign_key: true
  end
end
