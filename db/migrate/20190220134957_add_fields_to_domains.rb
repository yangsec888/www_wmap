class AddFieldsToDomains < ActiveRecord::Migration[5.2]
  def change
    add_column :domains, :imprint, :string
    add_column :domains, :current_redirect, :string
    add_column :domains, :new_redirect, :string
    add_column :domains, :pub_team, :string
    add_column :domains, :contact, :string
    add_column :domains, :notes, :string
  end
end
