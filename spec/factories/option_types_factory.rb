FactoryBot.define do
  factory :option_type, class: Spree::OptionType do
    factory :option_type_color do
      name { 'color' }
      presentation { 'Color' }
      position { 1 }
    end

    factory :option_type_size do
      name { 'size' }
      presentation { 'Size' }
      position { 2 }
    end

    factory :option_type_material do
      name { 'material' }
      presentation { 'material' }
      position { 3 }
    end
  end # option_types

  factory :option_value, class: Spree::OptionValue do
    %w|white black grey red|.each.with_index do|_color, _index|
      factory "option_value_#{_color}".to_sym do
        position { _index }
        name { _color }
        presentation { _color.titleize }
      end
    end

    %w|xs s m l xl|.each.with_index do|_size, _index|
      factory "option_value_#{_size}".to_sym do
        position { _index }
        name { _size }
        presentation { _size }
      end
    end

    %w|cotton silk metal aluminum|.each.with_index do|_material, _index|
      factory "option_value_#{_material}".to_sym do
        position { _index }
        name { _material }
        presentation { _material.titleize }
      end
    end
  end
end