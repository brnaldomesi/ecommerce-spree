class Retail::ProductPhoto < ::RetailScraperRecord
  self.table_name = 'retail_product_photos'

  validates_presence_of :retail_product_id

  belongs_to :retail_product, class_name: 'Retail::Product'

  def to_s
    inspect
  end

  def inspect
    "Retail::Photo(#{id}) for Product(#{retail_product_id}) from #{url}"
  end

  # TODO: implement those that a mounted uploader provides.

  def image_url

  end

  def thumbnail_url

  end

end