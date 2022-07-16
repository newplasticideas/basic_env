require_relative 'product'
class Item
  # {
  #   "orderId": 1122,
  #   "productId": 1,
  #   "quantity": 4,
  #   "costPerItem": 10.45
  # },
  attr_accessor :order_id, :product_id, :quantity, :cost_per_item, :product

  def initialize json
    self.order_id = json["orderId"]
    self.product_id = json["productId"]
    self.quantity = json["quantity"]
    self.cost_per_item = json["costPerItem"]
    self.product = Product.all.detect { |product| product.product_id == self.product_id }
  end

  def insufficient_stock?
    self.product.out_of_stock? || self.quantity > self.product.quantity_on_hand
  end

  def order_exceeds_product_threshold?
    self.quantity > self.product.reorder_threshold
  end

end