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
    # self.product = 
  end

  def out_of_stock

  end

end