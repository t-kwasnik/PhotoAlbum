class AddDateField < ActiveRecord::Migration
  def change
    add_column :photos, :original_date, :time
  end
end
