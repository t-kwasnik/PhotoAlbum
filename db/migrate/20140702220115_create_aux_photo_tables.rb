class CreateAuxPhotoTables < ActiveRecord::Migration
  def change
    [:cities, :states, :countries]. each do |table|
      create_table table do |t|
        t.string :name, null: false
        t.timestamps
      end
      add_index table, :name, unique: true
    end

    create_table :tags do |t|
      t.string :name, null: false
      t.integer :category_id, null: false
      t.timestamps
    end

    create_table :categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :categories, :name, unique: true

    create_table :photo_tags do |t|
      t.integer :tag_id, null: false
      t.integer :photo_id, null: false
      t.timestamps
    end

  end
end
