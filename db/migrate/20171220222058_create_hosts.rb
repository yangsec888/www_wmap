class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :host_name
      t.string :ip
      t.integer :uid

      t.timestamps null: false
    end
  end
end
