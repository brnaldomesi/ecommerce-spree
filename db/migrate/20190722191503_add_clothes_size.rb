class AddClothesSize < ActiveRecord::Migration[5.2]
  def change
    puts ' .. Clothing size ---------------------------'
    clothing_size = ::Spree::OptionType.where(presentation: ['clothes size', 'clothing size'] ).first
    general_size = ::Spree::OptionType.where(presentation: 'size' ).first
    clothing_size ||= general_size || ::Spree::OptionType.new

    clothing_size.name = 'clothing size'
    clothing_size.presentation = 'Clothing Size'
    clothing_size.position = 1
    clothing_size.save

    if general_size.id != clothing_size.id
      ::Spree::OptionValue.where(option_type_id: general_size.id).update_all(clothing_size.id)
      ::Spree::ProductOptionType.where(option_type_id: general_size.id).update_all(clothing_size.id)
    end

    position = 1
    clothing_size_values = [
      'Extra Small' => 'XS',
      'Small' => 'S',
      'Medium' => 'M',
      'Large' => 'L',
      'Extra Large' => 'XL',
      'Extra Extra Large' => 'XXL',
      '4' => '4',
      '5' => '5',
      '6' => '6',
      '7' => '7',
      '8' => '8',
      '10' => '10',
      '12' => '12',
      '14' => '14',
      '16' => '16',
      '18' => '18',
      '20' => '20',
      'New Born' => 'NB',
      '3 Months' => '3M',
      '6 Months' => '6M',
      '9 Months' => '9M',
      '12 Months' => '12M',
      '18 Months' => '18M',
      '24 Months' => '24M',
      'Toddler Size 2' => '2T',
      'Toddler Size 3' => '3T',
      'Toddler Size 4' => '4T'
    ]
    clothing_size_values.each do|h|
      name = h.keys.first
      v = h[h.keys.first]
      cur_ov = ::Spree::OptionValue.find_or_create_by(option_type_id: clothing_size.id, presentation: v) do|ov|
        ov.name = name
      end
      cur_ov.name = name
      cur_ov.position = position
      cur_ov.save
      position += 1
    end

    puts 'Shoe size ---------------------------------'
    shoe_size = ::Spree::OptionType.where(name: ['shoe size', 'shoes size'] ).first
    shoe_size ||= ::Spree::OptionType.create(name: 'shoe size', presentation: 'Shoe Size', position: 2)
    shoe_size_values = %w|0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20|
    shoe_size_values += %w|40 40.5 41 41.5 42 42.5 43 43.5 44 44.5 45 45.5 46 46.5 47 47.5|
    shoe_size_values.each_with_index do|v, idx|
      cur_ov = ::Spree::OptionValue.find_or_create_by(option_type_id: shoe_size.id, presentation: v) do|ov|
        ov.name = v
      end
      cur_ov.name = v
      cur_ov.position = idx + 1
      cur_ov.save
    end
  end
end
