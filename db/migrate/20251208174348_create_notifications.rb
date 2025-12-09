class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.text :message, null: false
      t.string :notification_type, null: false
      t.boolean :read, default: false
      t.timestamps
    end
    
    add_index :notifications, :user_id
    add_index :notifications, [:user_id, :read]
    add_index :notifications, :created_at
  end
end
