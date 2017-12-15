class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :uid
      t.string :name
      t.string :attachment

      t.timestamps null: false
    end
  end
end
