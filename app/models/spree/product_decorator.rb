module Spree
  Product.class_eval do

    require 'open-uri'

    # @return <Array of Spree::Image>
    def copy_images_from_retail_product!(retail_product)
      retail_product.product_photos.collect{|product_photo| copy_from_retail_product_photo!(product_photo) }
    end

    ##
    # @product_photo <Retail::ProductPhoto>
    # @return <Spree::Image> added photo if successfully copied/downloaded
    def copy_from_retail_product_photo!(product_photo_or_url)
      spree_image = nil
      url = product_photo_or_url.is_a?(::Retail::ProductPhoto) ? product_photo_or_url.image_url : product_photo_or_url.to_s
      if url.present?
        if url.start_with?('/') # copy local
          file_path = File.join(Rails.root.to_s, 'public', url)
          puts "ProductPhoto.image at #{file_path}, exists? #{File.exists?(file_path)}"
          Spree::Image.create(:attachment => File.open(file_path), :viewable => self.master)

        else # download
          open(url) do|image|
            Spree::Image.create(:attachment => image, :viewable => self.master)
          end
        end
      end
      spree_image
    rescue Exception => e
      logger.warn "** Spree::Product(#{id}): #{e.message}"
      spree_image
    end
  end
end