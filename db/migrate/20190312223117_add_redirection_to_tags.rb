class AddRedirectionToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :redirection, :string
    rename_column :tags, :site_url, :site

  end
end
