class AddExtraValueSpreeOptionValues < ActiveRecord::Migration[5.2]
  def change

    add_column :spree_option_values, :extra_value, :string, length: 255
  end
end
