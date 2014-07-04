class UpdateUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :username, :string
    add_column :users, :image, :string
    add_column :users, :phone_number, :integer
  end
end
