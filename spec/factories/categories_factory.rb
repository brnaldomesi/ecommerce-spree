FactoryBot.define do
  # site_name, other_site_category_id, mapped_taxon_id, parent_id, position, name, lft, rgt, depth
  factory :site_categories, class: ::SiteCategory do
    factory :level_one_site_category, aliases: [:ioffer_level_one_site_category] do
      site_name { 'ioffer' }
      other_site_category_id { 12000 }
      name { 'Clothing & Accessories' }
    end

    factory :level_two_site_category, aliases: [:ioffer_level_two_site_category] do
      site_name { 'ioffer' }
      other_site_category_id { 1010285 }
      name { "Men's Clothing" }
    end

    factory :level_three_site_category, aliases: [:ioffer_level_three_site_category] do
      site_name { 'ioffer' }
      other_site_category_id { 1010402 }
      name { 'Shirts' }
    end
  end
end