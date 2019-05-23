FactoryBot.define do
  factory :retail_product, class: Retail::Product do

    factory :basic_retail_product, aliases: [:ioffer_retail_product, :dress_retail_product] do
      title { 'FENDI NEW WOMEN FASHION DRESS' }
      price { 15.0 }
      original_price { 20.0 }
      description { "S:Bust 74CM, Shoulder 46CM, Length 68CM\nM: Bust 78CM, Shoulder 48CM, Length 70CM\nL: Bust 82CM, Shoulder 50CM, Length 72CM\nXL: Bust 86CM, Shoulder 52CM, Length 74CM\nXXL: Bust 90CM, Shoulder 54CM, Length 76CM" }
      categories { '[{"name":"Clothing & Accessories","url":"https://www.ioffer.com/c/Clothing-Accessories-120000/"},{"name":"Women''s Clothing","url":"https://www.ioffer.com/c/Women-s-Clothing-1010292/"},{"name":"Dresses","url":"https://www.ioffer.com/c/Women-s-Dresses-1010349/"}]' }
      association :retail_site, factory: :ioffer
    end

    factory :shirt_retail_product, aliases: [:ioffer_retail_product_2] do
      title { 'New Mens Slim Fit Casual Dress Shirts 3Colors ' }
      price { 16.95 }
      original_price { 22.0 }
      description { "U.S Size\r Measurement\r \rShoulder\r Chest(From armpit to armpit)\r Length\r Sleeve\rS\r 43cm(16.9\")\r 98cm(38.6\")\r 72cm(28.3\")\r 61cm(24.0\")\rM\r 44cm(17.3\")\r 102cm(40.2\")\r 73cm(28.7\")\r 62cm(24.4\")\rL\r 45cm(17.7\")\r 106cm(41.7\")\r 75cm(29.5\")\r 63cm(24.8\")\rXL\r 46cm(18.1'')\r 110cm(43.3'')\r 76cm(29.9'')\r 64cm(25.2'')\rPayment:\r\rWe only accept Paypal.Please send payment within 3 days after the auctions closed." }
      categories { "[{\"name\":\"Clothing & Accessories\",\"url\":\"https://www.ioffer.com/c/Clothing-Accessories-120000/\"},{\"name\":\"Men's Clothing\",\"url\":\"https://www.ioffer.com/c/Men-s-Clothing-1010285/\"},{\"name\":\"Shirts\",\"url\":\"https://www.ioffer.com/c/Shirts-1010402/\"}]" }
      association :retail_site, factory: :ioffer
      after :create do|rp|
        [:product_spec_colors_white, :product_spec_colors_blue, :product_spec_brand_nike, :product_spec_material_cotton].each do|k|
          create k, product: rp
        end
      end
    end
  end


  ###########################################
  # Retail::Site

  factory :retail_site, class: Retail::Site do
    factory :ioffer do
      name { 'ioffer' }
      domain { 'ioffer.com' }
      initial_url { '/' }
      site_scraper { 'Scraper::Ioffer' }
    end
  end
end