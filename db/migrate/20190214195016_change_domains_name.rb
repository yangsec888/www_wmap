class ChangeDomainsName < ActiveRecord::Migration[5.2]
  def change
    rename_column :domains, :owed_domain, :name
    add_column :domains, :keep, :boolean
    
  end
end
