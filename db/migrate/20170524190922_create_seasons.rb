class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.integer :number
      t.references :series, foreign_key: true

      t.timestamps
    end
  end
end
