class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :owed_domain
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
