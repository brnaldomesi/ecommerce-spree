class MinimizeOptionTypes < ActiveRecord::Migration[5.2]
  def change
    wanted_list = %w|color size|
    others_query = ::Spree::OptionType.where('presentation NOT IN (?)', wanted_list)
    puts "Wanted option types: #{wanted_list}"
    puts "  while there r #{others_query.count} to be deleted"
    others_query.all.each(&:destroy)

    wanted_list.each_with_index do|option_name, index|
      puts "#{option_name} ------------------------"
      cur_option_types = ::Spree::OptionType.where(presentation: option_name).order('position asc').to_a
      first_option_type = cur_option_types.first || ::Spree::OptionType.create(name: option_name, presentation: option_name.titleize, position: index + 1)
      first_option_type.update(position: index + 1) if first_option_type != index + 1

      # move the others to this one
      if cur_option_types.size > 1
        puts "  .. merging the other #{cur_option_types.size - 1} duplicates to one"
        cur_option_types[1..-1].each do|other_option_type|
          other_option_type.option_values.update_all(option_type_id: first_option_type.id)
          other_option_type.product_option_types.update_all(option_type_id: first_option_type.id)
          other_option_type.destroy
        end
      end
    end

    wanted_list.each do|option_name|
      puts "#{option_name} ----------------------------"
      option_type = ::Spree::OptionType.where(presentation: option_name).first
      cur_position = 1
      ids = File.open( File.join(Rails.root, 'doc/option_values/' + option_name.pluralize + '.txt') ).lines.collect do|line|
        option_value = ::Spree::OptionValue.find_or_create_by(option_type_id: option_type.id, presentation: line.strip) do|ov|
            ov.name = line.strip
        end
        puts '%3d. %s' % [cur_position, option_value.presentation]
        option_value.update(position: cur_position)
        cur_position += 1
        option_value.id
      end
      ::Spree::OptionValue.where('option_type_id=? AND id NOT IN (?)', option_type.id, ids).each(&:destroy)
    end # wanted_list
  end
end
