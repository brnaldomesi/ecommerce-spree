FactoryBot.define do
  factory :other_site_categories, class: OtherSiteCategory do
    factory :level_one_other_site_category, aliases: [:ioffer_level_one] do
      site_name { 'ioffer' }
      name { 'Clothing & Accessories'}
      level { 1 }
      order_index { 1 }
      full_path { 'Clothing & Accessories' }
    end

    factory :level_two_other_site_category, aliases: [:ioffer_level_two] do
      site_name { 'ioffer' }
      name { "Men's Clothing" }
      level { 2 }
      order_index { 1 }
      full_path { "Clothing & Accessories > Menu's Clothing" }
      association :parent, factory: :ioffer_level_one
    end

    factory :level_thee_other_site_category, aliases: [:ioffer_level_three] do
      site_name { 'ioffer' }
      name { 'Shirts' }
      level { 3 }
      order_index { 1 }
      full_path { "Clothing & Accessories > Menu's Clothing > Shirts" }
      association :parent, factory: :ioffer_level_two
    end
  end
end