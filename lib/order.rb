require 'state_machines'
require_relative 'item'

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

  state_machine :status, initial: :pending do

    event :process do
      transition :pending => :fulfilled, unless: :unfulfillable
    end
  end

  def initialize(json)
    self.order_id     = json["orderId"]
    self.date_created = json["dateCreated"]
    self.status       = json["status"].downcase
    self.items        = set_items(json["items"])
  end

  def unfulfillable
    self.items.any? &:out_of_stock?
  end

  def set_items(json)
    json.map {|item| Item.new(item)}
  end
end