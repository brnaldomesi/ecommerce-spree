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
    factory :categories_taxon do
      position { 0 }
      name { 'Categories' }
      permalink { 'categories' }
      depth { 0 }
      taxonomy_id { ::Category.find_or_create_categories_taxonomy.id }
    end
  end
end