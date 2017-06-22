class AddReleaseDateToSeries < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :release_date, :date
  end
end
