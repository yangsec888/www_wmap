class AddCategoryToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :category, :string

  end
end
