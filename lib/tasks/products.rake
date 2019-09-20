namespace :products do

  ##
  #
  task :erase_duplicates => :environment do
    Spree::Product.group(:name).count.each_pair do|name, count|
      next if count < 2
      list = Spree::Product.where(name: name)
      # TODO: find best version, like one w/ existing images, and erase others
    end
  end

  task :erase_with_missing_images => :environment do
    Spree::Product.all.each do|product|
      ratio = images_existence_ratio(product)
      if ratio < 0.5
        puts '%4d | %60s | %20s | %f' % [product.id, product.name, product.user.try(:username).to_s, ratio ]
        product.really_destroy!
      end
    end
  end


  def images_existence_ratio(product)
    total_count = product.gallery.images.size
    exist_count = product.gallery.images.find_all do|img|
      uri = URI(img.url(:large) )
      file_path = File.join(Rails.root, 'public', uri.path)
      is_exist = File.exists?(file_path)
      img.destroy unless is_exist
      is_exist
    end.size
    total_count > 0 ? (exist_count / total_count.to_f) : 0
  end
end