class AddGeolocationField < ActiveRecord::Migration
  def change
    add_column :photos, :city, :string
    add_column :photos, :state, :string
    add_column :photos, :country, :string
  end
end
