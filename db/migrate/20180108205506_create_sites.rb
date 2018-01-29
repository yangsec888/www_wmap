class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :site
      t.integer :user_id
      t.string :ip
      t.integer :port
      t.string :url
      t.integer :code
      t.string :redirection
      t.string :md5
      t.string :server
      t.datetime :timestamp
      t.string :status

      t.timestamps null: false
    end
  end
end
