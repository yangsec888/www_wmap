class AddNetnameToCidrs < ActiveRecord::Migration[5.2]
  def change
    add_column :cidrs, :ref, :string
    add_column :cidrs, :netname, :string

  end
end
