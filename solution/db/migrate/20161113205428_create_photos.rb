class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
