class CreateNoticia < ActiveRecord::Migration[5.0]
  def change
    create_table :noticia do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.string :title

      t.timestamps
    end
    add_index :noticia, [:user_id, :created_at]
  end
end
