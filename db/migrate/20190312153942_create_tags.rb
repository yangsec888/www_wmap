class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :site_url
      t.string :name
      t.string :description
      t.string :signature
      t.text :sign_desc
      t.string :sign_ver

      t.timestamps
    end
  end
end
