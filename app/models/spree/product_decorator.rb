module Spree
  Product.class_eval do

    require 'open-uri'

    has_one :migration, class_name: 'Retail::ProductToSpreeProduct', foreign_key: :spree_product_id
    delegate :retail_product, to: :migration

    belongs_to :master_product, class_name: 'Spree::Product', foreign_key: :master_product_id

    def categories
      categories_taxon = ::Spree::CategoryTaxon.root
      self.taxons.where(parent_id: categories_taxon.id).first
    end

    # @return <Array of Spree::Image>
    def copy_images_from_retail_product!(retail_product)
      retail_product.product_photos.collect{|product_photo| copy_from_retail_product_photo!(product_photo) }
    end

    def create_categories_taxon!(retail_product)
      site_category = retail_product.leaf_site_category
      if site_category.try(:mapped_taxon_id)
        ::Spree::Classification.find_or_create_by(product_id: id, taxon_id: site_category.mapped_taxon_id) do|c|
          c.position = 1
        end
      end
    end

    ##
    # Some specs are simply existing option types such as color, as could represent a variant while
    # they are still created as properties with joined values as safe backup of the original names and values.
    def copy_product_specs_from_retail_product!(retail_product, create_new_option_value = false)

      ::Retail::ProductSpec.normalize_product_specs(retail_product.product_specs)
      group = retail_product.product_specs.group_by(&:name)
      option_types = ::Spree::OptionType.where(name: group.keys).all
      option_types_group = option_types.group_by(&:name)
      option_values_group = Spree::OptionValue.where(option_type_id: option_types.collect(&:id)).group_by(&:option_type_name)
      variant_ids = self.variants_including_master.to_a.collect(&:id)

      group.each_pair do|spec_name, spec_list|
        self.set_property_with_list(spec_name, spec_list)

        # Try to create variants for this spec name and values
        option_values = option_values_group[spec_name] || []
        if create_new_option_value || option_values
          option_type = option_types_group[spec_name.downcase].try(:first) || option_values.first.try(:option_type)
          next if option_type.nil?

          product_option_type = self.product_option_types.find{|ot| ot.id == option_type.id }
          self.product_option_types.create(position: self.product_option_types.size + 1, product_id: id, option_type_id: option_type.id) if product_option_type.nil?

          spec_list.each do|spec|
            option_value = option_values.find{|var| var.presentation.downcase == spec.value_1.downcase }
            is_new_option_value = false
            unless option_value
              option_value ||= Spree::OptionValue.create(option_type_id: option_type.id,
                position: option_values.size, name: spec.value_1, presentation: spec.value_1)
              option_values << option_value
              is_new_option_value = true
            end
            # see if variant is attached
            if is_new_option_value || Spree::OptionValuesVariant.where(variant_id: variant_ids, option_value_id: option_value.id).count == 0
              new_variant = self.variants.create(product_id: id, price: master.price)
              Spree::OptionValuesVariant.create(variant_id: new_variant.id, option_value_id: option_value.id)
            end
          end
        end
      end
      self.save
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
          logger.debug "ProductPhoto.image at #{file_path}, exists? #{File.exists?(file_path)}"
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


    ##
    # Since there is DB column limit of 100, need to join manually
    def set_property_with_list(spec_name, spec_list)
      return if spec_name.blank? || spec_list.blank?
      value_s = ''
      spec_list.uniq.each do|spec|
        if value_s.size + spec.value_1.to_s.size + 1 < 100
          value_s << ' ' unless value_s == ''
          value_s << spec.value_1.to_s
        else
          break
        end
      end
      self.set_property(spec_name, value_s) if value_s.present?
    end

  end # class_eval
end