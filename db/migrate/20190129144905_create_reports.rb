class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :title
      t.text :description
      t.string :division
      t.string :department
      t.boolean :published

      t.timestamps
    end
  end
end
