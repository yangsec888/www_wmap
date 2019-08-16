class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.string :name
      t.string :attachment
      t.string :file_type
      t.string :switch_tag

      t.timestamps
    end
  end
end
