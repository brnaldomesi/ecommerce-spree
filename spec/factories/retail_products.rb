FactoryBot.define do
  factory :retail_product, class: Retail::Product do

    factory :basic_product, aliases: [:ioffer_product, :dress] do
      title { 'FENDI NEW WOMEN FASHION DRESS' }
      price { 15.0 }
      original_price { 20.0 }
      description { "S:Bust 74CM, Shoulder 46CM, Length 68CM\nM: Bust 78CM, Shoulder 48CM, Length 70CM\nL: Bust 82CM, Shoulder 50CM, Length 72CM\nXL: Bust 86CM, Shoulder 52CM, Length 74CM\nXXL: Bust 90CM, Shoulder 54CM, Length 76CM" }
      categories { '[{"name":"Clothing \u0026 Accessories","url":"https://www.ioffer.com/c/Clothing-Accessories-120000/"},{"name":"Women''s Clothing","url":"https://www.ioffer.com/c/Women-s-Clothing-1010292/"},{"name":"Dresses","url":"https://www.ioffer.com/c/Women-s-Dresses-1010349/"}]' }
    end
  end
end