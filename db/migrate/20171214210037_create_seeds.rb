class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.integer :uid
      t.text :hosts
      t.text :ips
      t.text :cidrs
      t.string :entity_name
      t.boolean :verified

      t.timestamps null: false
    end
  end
end
