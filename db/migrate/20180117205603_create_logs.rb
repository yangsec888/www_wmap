class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.string :file_name

      t.timestamps null: false
    end
  end
end
