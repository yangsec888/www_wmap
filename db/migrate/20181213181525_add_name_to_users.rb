class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :employee_type, :string
    add_column :users, :employee_number, :string

  end
end
