class SetSomePricesOfProductsAsRequired < ActiveRecord::Migration[5.2]
  def change
    cnt = 0
    Spree::Product.all.each{|p| cnt += 1 if p.price.to_f == 0.0 }.size
    puts "Count of products w/ 0 price: #{cnt}"
    if cnt > 0
      idx = 0
      Spree::Product.all.each do|p|
        next if p.price.to_f > 0.0
        p.price = p.prices.find(&:amount).try(:amount)
        p.price = 10 + rand(1500) / 100.0 unless p.price.to_f > 0.0 # some has simply 0.0
        p.save
        idx += 1
        puts " .. #{idx}" if idx % 50 == 0
      end
    end
  end
end
