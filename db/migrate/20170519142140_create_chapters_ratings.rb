class CreateChaptersRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters_ratings do |t|
      t.integer :rating
      t.references :user, foreign_key: true
      t.references :chapter, foreign_key: true

      t.timestamps
    end
  end
end
