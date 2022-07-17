require 'json'
require 'pry'
require_relative 'order'
require_relative 'product'
class OrderFulfillment
  # As a warehouse officer
  # I want to be able to initiate an order run
  # So that I can deliver orders according to my pending orders and inventory availability
  attr_accessor :products, :orders, :unfulfillable_orders

  def initialize
    self.products = get_products
    self.orders = get_orders
    self.unfulfillable_orders = []
  end

  # It will accept an array of Order IDs to process orders for fulfilment and shipping.
  # If an order cannot be fulfilled due to low stock levels, it should not be fulfilled.
  # It should return an array of order ids that were unfulfillable.
  def process_orders order_ids
    unfulfillable_orders = []
    to_process = self.orders.select {|order| order_ids.include?(order.order_id) && order.pending? }

    return "order not found" if to_process.empty?

    to_process.each do |order|
      puts "processing order ##{order.order_id}"
      if order.unfulfillable?
        puts "order ##{order.order_id} could not be fulfilled. #{order.items.map(&:error).compact.join}"
        order.mark_unfulfillable
        unfulfillable_orders << order
      else
        order.items.each do |item|
          product = self.products.detect {|p| p.product_id == item.product_id}
          puts "#{product.description} found, ##{product.quantity_on_hand} left in stock. processing..."
          self.products.each do |p|
            # i don't think creating a new variable from the relevant product would persist any changes,
            # so I have to loop through the data on self.
            if p.product_id == product.product_id
              puts "reducing #{p.description} availability by #{item.quantity}"
              p.quantity_on_hand -= item.quantity
              puts "#{p.quantity_on_hand} left on hand."
            end
          end
        end
        order.process
        puts "order ##{order.order_id} processed!"
      end
    end
    unfulfillable_orders.map &:order_id
  end

  def get_orders
    @orders ||= self.class.database["orders"].map { |order| Order.new(order) }
  end

  def get_products
    @products ||= self.class.database["products"].map { |product| Product.new(product) }
  end



  # CLASS METHODS
  class << self

    def database
      @database ||= JSON.parse(self.database_path)
    end

    private

    def data
      @data ||= JSON.parse(self.database_path)
    end

    def database_path
      @database_path ||= File.read("#{self.root}/data.json")
    end

    def root
      @root ||= File.dirname(__dir__)
    end
  end
end