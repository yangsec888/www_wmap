class ChangeDomainsKeepType < ActiveRecord::Migration[5.2]
  def change
    change_column :domains, :keep, :string
  end
end
