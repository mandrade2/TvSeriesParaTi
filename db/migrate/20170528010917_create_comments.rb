class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :series, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
