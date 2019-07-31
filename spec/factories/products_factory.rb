FactoryBot.define do
  factory :products, class: Spree::Product do
    factory :basic_product, aliases: [:home_product] do
      name {'12 in. Pre-Seasoned Cast Iron Skillet'}
      description {"Pre-seasoned skillet distributes heat evenly\r\nMeasures 12 in. D x 2.25 in. H\r\nSuitable for indoor or outdoor cooking"}
      price {13}
      cost_price {10}
      cost_currency {'USD'}
      sku {'UTENSILS350'}
      height {'12 in'}
      width {'12 in'}
      depth {'2 in'}
      weight {'2 lbs'}
      shipping_category_id { (Spree::ShippingCategory.default || create(:shipping_category)).id }
      tax_category_id { (Spree::TaxCategory.default || create(:tax_category)).id }
      taxon_ids { create(:home_taxon).id.to_s }
      option_type_ids {  }
      meta_title {'Cast Iron Skillet'}
      meta_keywords {'cast iron skillet'}
      meta_description {'Pre-seasoned skillet distributes heat evenly'}
    end
  end

  factory :assets, class: Spree::Asset do
    factory :images, class: Spree::Image do
      factory :local_image_file, aliases: [:sample_markers_image] do
        attachment { File.new( File.join(Rails.root, 'public/assets/sample/color_markers-f66e30f4c5033dd7202c8014c77ea2449aee6ab7b39fc05ab3dc75c410dfd4b4.jpg') ) }
      end
    end
  end

  factory :shipping_category, class: Spree::ShippingCategory do
    name {'Default'}
  end

  factory :tax_category, class: Spree::TaxCategory do
    name {'Default'}
  end

end