class RunFixExtraValueOfColorOptionValues < ActiveRecord::Migration[5.2]
  def change
    `rake sample_data:fix_extra_value_of_color_option_values`
  end
end
