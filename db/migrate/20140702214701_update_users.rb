class UpdateUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :username, :string
  end
end
