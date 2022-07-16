require 'state_machines'
require_relative 'item'
require_relative 'product'

class Order
  # {
  #   "orderId": 1122,
  #   "status": "Pending",
  #   "dateCreated": "2018-05-09 10:59",
  #   "items": [
  #     {
  #       "orderId": 1122,
  #       "productId": 1,
  #       "quantity": 4,
  #       "costPerItem": 10.45
  #     },
  #     {
  #       "orderId": 1122,
  #       "productId": 2,
  #       "quantity": 7,
  #       "costPerItem": 20.95
  #     }
  #   ]
  # }
  attr_accessor :order_id, :date_created, :items, :status
  @@orders = []

  def initialize(json)
    self.order_id     = json["orderId"]
    self.date_created = json["dateCreated"]
    self.status       = json["status"].downcase
    self.items        = set_items(json["items"])
    @@orders << self
  end

  state_machine :status, initial: :pending do

    event :process do
      transition :pending => :fulfilled, unless: :unfulfillable
    end

    # after_transition :pending => :fulfilled do |order, _transition, block|
    #   order.items.each do |item|
    #     product = Product.all.detect {|p| p.product_id == item.product_id}
    #     product.quantity_on_hand -= item.quantity
    #   end
    # end
  end

  def unfulfillable
    self.items.any? &:insufficient_stock?
  end

  def product_ids
    self.items.map &:product_id
  end

  def products
    self.items.map &:product
  end

  def set_items(json)
    json.map {|item| Item.new(item)}
  end

  def self.all
    @@orders
  end

end