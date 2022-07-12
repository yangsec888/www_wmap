class RemoveImprintFromDomains < ActiveRecord::Migration[5.2]
  def change
    remove_column :domains, :imprint
  end
end
