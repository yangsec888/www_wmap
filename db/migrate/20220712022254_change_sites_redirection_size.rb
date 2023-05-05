class ChangeSitesRedirectionSize < ActiveRecord::Migration[5.2]
  def change
    change_column :sites, :redirection, :text, :limit => 16777215

  end
end
