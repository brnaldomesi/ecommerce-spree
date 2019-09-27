Spree::LineItem.class_eval do
  belongs_to :product

  before_save :set_references

  private

  def set_references
    self.product_id = variant.product_id
  end
end