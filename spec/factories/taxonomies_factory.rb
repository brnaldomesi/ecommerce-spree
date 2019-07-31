FactoryBot.define do
  factory :taxonomies, class: Spree::Taxonomy do
    factory :categories_taxonomy do
      name { 'Categories' }
    end

    factory :brand_taxonomy do
      name { 'Brand' }
    end
  end

  factory :taxons, class: Spree::Taxon do
    # position { 0 }
    # depth { 0 }
    taxonomy_id { ::Category.find_or_create_categories_taxonomy.id }

    factory :level_one_category_taxon, aliases: [:clothing_category_taxon] do
      name { 'Clothing' }
      permalink { 'categories/clothing' }
    end

    factory :level_two_category_taxon, aliases: [:mens_clothing_category_taxon] do
      name { "Men's Clothing" }
      permalink { 'categories/mens-clothing' }
    end

    factory :level_three_category_taxon, aliases: [:shirts_category_taxon] do
      name { 'Shirts' }
      permalink { 'categories/mens-clothing-shirts' }
    end

    factory :home_taxon do
      name {'Home & Garden'}
      permalink {'home-garden'}
    end
  end
end