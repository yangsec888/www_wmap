class AddUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :department, :string
    add_column :users, :username, :string
    add_column :users, :role, :integer
    add_column :users, :dn, :string

  end
end
