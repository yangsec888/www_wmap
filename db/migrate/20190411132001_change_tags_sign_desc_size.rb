class ChangeTagsSignDescSize < ActiveRecord::Migration[5.2]
  def change
    change_column :tags, :sign_desc, :text, :limit => 16777215

  end
end
