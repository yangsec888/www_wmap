class AddDivisionToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :division, :string

  end
end
