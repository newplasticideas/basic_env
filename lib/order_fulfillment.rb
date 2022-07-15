require 'json'
require 'pry'
class OrderFulfillment
  # As a warehouse officer
  # I want to be able to initiate an order run
  # So that I can deliver orders according to my pending orders and inventory availability

  # CLASS METHODS
  class << self
    def database
      JSON.parse(File.read("#{File.dirname __dir__}/data.json"))
    end
  end
end