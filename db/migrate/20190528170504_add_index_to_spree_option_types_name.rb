class AddIndexToSpreeOptionTypesName < ActiveRecord::Migration[5.2]
  def change
    add_index :spree_option_types, :name
  end
end
