class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.point :geom, :geographic => true, :has_z => true
      t.float :direction
      t.integer :user_id, null: false
      t.boolean :is_public, default: false
      t.string :name
      t.text :description, default: "none"
      t.text :placename
      t.integer :city_id
      t.integer :state_id
      t.integer :country_id
      t.string :image, null: false
      t.timestamps
    end
  end
end
