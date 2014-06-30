class CreateAddDirectionField < ActiveRecord::Migration
  def change
    add_column :photos, :direction, :float
  end
end
