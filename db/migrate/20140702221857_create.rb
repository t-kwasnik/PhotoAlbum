class Create < ActiveRecord::Migration
  def change
      create_table :my_maps do |t|
        t.integer :user_id, null: false
        t.string :name, null: false
        t.text :description
        t.boolean :is_public, default: false
        t.string :public_url_key
        t.timestamps
      end

      create_table :my_map_photos do |t|
        t.integer :my_map_id, null: false
        t.integer :photo_id, null: false
        t.integer :order, null: false
        t.text :description
        t.timestamps
      end
  end
end
