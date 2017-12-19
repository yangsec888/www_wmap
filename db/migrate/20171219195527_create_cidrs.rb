class CreateCidrs < ActiveRecord::Migration
  def change
    create_table :cidrs do |t|
      t.string :owed_cidr
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
