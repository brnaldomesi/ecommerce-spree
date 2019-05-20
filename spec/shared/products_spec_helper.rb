module ProductsSpecHelper
  def create_retail_product(product_factory_key, image_urls = [], properties = {})
    product = create(product_factory_key)
    product.product_photos = image_urls.collect do|url|
      p = ::Retail::ProductPhoto.create(retail_product_id: product.id, url: url)
      p.remote_image_url = url
      p.save
      p
    end
    product
  end

  def cleanup_retail_products
    ::Retail::Product.all.each(&:destroy)
  end
end