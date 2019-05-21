FactoryBot.define do
  factory :taxonomies, class: Spree::Taxonomy do
    factory :categories_taxonomy do
      name { 'Categories' }
    end

    factory :brand_taxonomy do
      name { 'Brand' }
    end
  end
end