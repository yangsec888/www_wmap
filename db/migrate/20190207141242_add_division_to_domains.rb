class AddDivisionToDomains < ActiveRecord::Migration[5.2]
  def change
    add_column :domains, :division, :string
    add_column :domains, :transferable, :boolean
  end
end
