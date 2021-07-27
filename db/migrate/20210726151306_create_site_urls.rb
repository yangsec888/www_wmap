class CreateSiteUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :site_urls do |t|
      t.string :site
      t.string :url
      t.string :req_method
      t.integer :code
      t.integer :user_id

      t.timestamps
    end
  end
end
