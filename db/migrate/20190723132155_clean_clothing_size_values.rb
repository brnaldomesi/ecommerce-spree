class CleanClothingSizeValues < ActiveRecord::Migration[5.2]
  def change
    # Copied from last migration db/migrate/20190722191503_add_clothes_size.rb
    clothing_size = ::Spree::OptionType.where(name: ['clothes size', 'clothing size'] ).first
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
    clothing_size_presentations = clothing_size_values.first.values
    deprecated_values = clothing_size.option_values.where('presentation NOT IN (?)', clothing_size_presentations )
    deprecated_values.each(&:destroy)
  end
end
