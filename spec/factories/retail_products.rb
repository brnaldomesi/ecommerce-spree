FactoryBot.define do
  factory :retail_product, class: Retail::Product do

    factory :basic_retail_product, aliases: [:ioffer_retail_product, :dress_retail_product] do
      title { 'FENDI NEW WOMEN FASHION DRESS' }
      price { 15.0 }
      original_price { 20.0 }
      description { "S:Bust 74CM, Shoulder 46CM, Length 68CM\nM: Bust 78CM, Shoulder 48CM, Length 70CM\nL: Bust 82CM, Shoulder 50CM, Length 72CM\nXL: Bust 86CM, Shoulder 52CM, Length 74CM\nXXL: Bust 90CM, Shoulder 54CM, Length 76CM" }
      categories { '[{"name":"Clothing \u0026 Accessories","url":"https://www.ioffer.com/c/Clothing-Accessories-120000/"},{"name":"Women''s Clothing","url":"https://www.ioffer.com/c/Women-s-Clothing-1010292/"},{"name":"Dresses","url":"https://www.ioffer.com/c/Women-s-Dresses-1010349/"}]' }
      association :retail_site, factory: :ioffer
    end

    factory :shirt_retail_product, aliases: [:ioffer_retail_product_2] do
      title { 'New Mens Slim Fit Casual Dress Shirts 3Colors ' }
      price { 16.95 }
      original_price { 22.0 }
      description { "U.S Size\r Measurement\r \rShoulder\r Chest(From armpit to armpit)\r Length\r Sleeve\rS\r 43cm(16.9\")\r 98cm(38.6\")\r 72cm(28.3\")\r 61cm(24.0\")\rM\r 44cm(17.3\")\r 102cm(40.2\")\r 73cm(28.7\")\r 62cm(24.4\")\rL\r 45cm(17.7\")\r 106cm(41.7\")\r 75cm(29.5\")\r 63cm(24.8\")\rXL\r 46cm(18.1'')\r 110cm(43.3'')\r 76cm(29.9'')\r 64cm(25.2'')\rPayment:\r\rWe only accept Paypal.Please send payment within 3 days after the auctions closed.We don't keep item and will send unpaid strike if didn't get payment within 7 days.If you have any problem on payment.please contact us before bid on the item.thank you. \rRefund Policy: \r\rYou may return the item to get refund(exclude shipping fee).You must send it back in original condition within 3 days after received.Return shipping in your expense.thank you.\rPostage: \r\rWe ship the item Via Air Mail within 48 hours when get your payment.We will send a mail to your ebay registered E-mail after sending your item(s),welcome bid,thanks\rDescription:\r\r1. We will ONLY ship to buyer's eBay registered address. If you need to change your shipping address, please change it on eBay BEFORE you pay. After pay, we will NOT accept to change shipping address. So that please make sure your shipping address is available. \r2.Sometimes, shipping time could be taken longer during Holiday(like Christams etc.) or Customs Duty Review. We could NOT be responsible for any delay of this two reasons.\r3. Please notice that the main shipping channel is Airmail by China Post.this is an international shipment which depends on local postal services' efficiency, therefore we can't assure exact time of delivery.You will receive the items about 15-25 days.\r4.if you are satisfied with our service, please leave us a positive feedback,thank you." }
      categories { "[{\"name\":\"Clothing \\u0026 Accessories\",\"url\":\"https://www.ioffer.com/c/Clothing-Accessories-120000/\"},{\"name\":\"Men's Clothing\",\"url\":\"https://www.ioffer.com/c/Men-s-Clothing-1010285/\"},{\"name\":\"Shirts\",\"url\":\"https://www.ioffer.com/c/Shirts-1010402/\"}]" }
      association :retail_site, factory: :ioffer
    end
  end

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