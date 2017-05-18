class CreateChapters < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :duration
      t.references :series, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
