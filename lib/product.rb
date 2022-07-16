class Product
  attr_accessor :product_id, :description, :quantity_on_hand, :reorder_threshold, :reorder_amount, :delivery_lead_time

  def initialize(json)
    self.product_id         = json["productId"]
    self.description        = json["description"]
    self.quantity_on_hand   = json["quantityOnHand"]
    self.reorder_threshold  = json["reorderThreshold"]
    self.reorder_amount     = json["reorderAmount"]
    self.delivery_lead_time = json["deliveryLeadTime"]
  end

  def out_of_stock
    self.quantity_on_hand.zero?
  end
end
