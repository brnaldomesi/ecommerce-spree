module Jobs
  class OrderJob
    include Sidekiq::Worker

    def perform(order_id)
      order = Spree::Order.where(id: order_id).first
      if order && order.complete?
        Spree::Order.logger.info "Performing Product GMS for Order ##{order_id}"
        self.class.recalculate_product_gms(order)
      end
    end

    def self.recalculate_product_gms(order)
      Spree::LineItem.joins(:order).where(product_id: order.line_items.collect(&:product_id) )
          .where("#{Spree::Order.table_name}.state='complete'").group('product_id')
          .sum("#{Spree::Order.table_name}.item_total").each_pair do|product_id, total_of_all|
        ::Spree::Product.where(id: product_id).update(gross_merchandise_sales: total_of_all)
      end
    end
  end
end