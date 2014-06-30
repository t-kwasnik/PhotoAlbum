class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.point :geom, :geographic => true, :has_z => true
    end
  end
end
