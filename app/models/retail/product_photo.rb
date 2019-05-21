module Retail
  class ProductPhoto < ::RetailScraperRecord
    self.table_name = 'retail_product_photos'


    mount_uploader :image, ::ImageUploader

    validates_presence_of :retail_product_id

    belongs_to :retail_product, class_name: 'Retail::Product'

    before_destroy :delete_file

    def to_s
      inspect
    end

    def inspect
      "Retail::Photo(#{id}) for Product(#{retail_product_id}) from #{url}"
    end

    protected

    def delete_file
      `rm -Rf #{File.dirname(self.image.store_dir) }`
    end
  end
end