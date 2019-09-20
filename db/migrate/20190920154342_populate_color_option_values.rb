class PopulateColorOptionValues < ActiveRecord::Migration[5.2]
  def change
    `rake sample_data:import_color_names`
    `rake sample_data:import_colors_from_csv`
  end
end
