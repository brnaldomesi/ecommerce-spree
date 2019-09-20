module Spree
  module OptionTypeService

    def import_color_names_from_file(file_path)
      doc = File.open( file_path ) { |f| Nokogiri::HTML(f) }
      count = 0
      doc.xpath("//tr[@class='color']").each do|color_tr|
        h = {}
        color_tr.children.each do|td|
          if td['class'] =~ /\bcolor-name\b/i
            h[:name] = td.text.strip
          elsif td['class'] =~ /\bcolor-hex\b/i
            h[:hex] = td.text.strip
          end
        end
        count += 1
        ::Spree::OptionType.where("name LIKE '%color'").each do|option_type|
          ov = option_type.option_values.where(presentation: h[:name]).first
          ov ||= ::Spree::OptionValue.new(position: count, name: h[:name], presentation: h[:name], option_type_id: option_type.id)
          ov.extra_value = h[:hex]
          ov.save
        end
        puts '%16s | %s' % [ h[:name], h[:hex] ]
      end
      puts "| Total of #{count} colors found"
    end

    ##
    # Expected format:
    # color_name,value,extra_value
    def import_colors_from_csv(file_path)
      ::Spree::OptionType.where("name LIKE '%color'").each do|option_type|
        puts "Option Type: #{option_type.name} (#{option_type.id}) ------------------------------------"
        File.open(file_path).readlines.each_with_index do|line, count|
          cols = line.split(',')
          name = cols[0].gsub('\\', ' / ')
          ov = option_type.option_values.where(presentation: name ).first
          ov ||= ::Spree::OptionValue.new(position: count + 1, name: name, presentation: name, option_type_id: option_type.id)
          ov.extra_value = cols[2].present? ? cols[1] + ',' + cols[2] : cols[1]
          ov.save
          puts '%4d | %30s | %s' % [ov.id, ov.name, ov.extra_value]
        end
      end
    end

    ##
    # Fixes:
    #   1. multiple colors that have, try to fill in hex values from single colors; but if not all, delete
    #   2. resort position of colors: basic single colors, other single colors, color combos
    def fix_color_option_values
      ::Spree::OptionType.where("name LIKE '%color'").each do|ot|
        puts "Option Type: #{ot.name} (#{ot.id}) ------------------------------------"
        ot.option_values.where('name LIKE \'%/%\' OR name LIKE \'%\%\'').each do|ov|
          next if ov.extra_value.present? && ov.extra_value.index(',')
          single_colors = ov.name.split(/(\/|\\)/ )
          hex_values = single_colors.collect do|color_name|
            ot.option_values.where(name: color_name.strip).first.try(:extra_value)
          end.compact
          if hex_values.find{|v| v.blank? }
            puts '%4d | %30s | %16s | %s *** DELETE' % [ov.id, ov.name, ov.extra_value.to_s, hex_values.to_s]
            ov.destroy
          else
            puts '%4d | %30s | %16s | %s' % [ov.id, ov.name, ov.extra_value.to_s, hex_values.to_s]
            ov.update(extra_value: hex_values.join(',') )
          end
        end

        puts "Fixing positions of colors: basic single colors, other single colors, color combos\n"
        position = 1
        priority_names = %w(red green blue black white gray orange purple gold silver brown pink)
        priority_names.each do|p_name|
          ov = ot.option_values.where(name: p_name).first
          next if ov.nil?
          puts '%4d | %30s | %s' % [position, ov.name, ov.extra_value.to_s]
          ov.update(position: position)
          position += 1
        end
        ot.option_values.single_names.where('name NOT IN (?)', priority_names).each do|ov|
          puts '%4d | %30s | %s' % [position, ov.name, ov.extra_value.to_s]
          ov.update(position: position)
          position += 1
        end

        ot.option_values.multi_word_names.order('position asc').each do|ov|
          puts '%4d | %30s | %s' % [position, ov.name, ov.extra_value.to_s]
          ov.update(position: position)
          position += 1
        end
      end

    end

  end
end