# Coding challenge: Order Fulfilment

### User Story

As a warehouse officer

I want to be able to initiate an order run 

So that I can deliver orders according to my pending orders and inventory availability
Background

New Order Management System Services (NOMSS) has been created to manage our customer orders and order fulfilment processes, and will replace our legacy system. Your task it to implement the core order fulfilment logic that will form part of NOMSS.
A sample data file data.json has been provided. It contains collections of products and orders; feel free to use this file as you see fit, but don’t modify it. Each time your sample application runs it should read from the unmodified file.
Requirements

1. Provide a class or set of classes that can be used to perform order fulfilment, along with some basic instructions on how to use.
2. Provide a clear entry point into the order-fulfilment code, e.g. a method named processOrders()
    - It will accept an array of Order IDs to process orders for fulfilment and shipping.
    - If an order cannot be fulfilled due to low stock levels, it should not be fulfilled.
    - It should return an array of order ids that were unfulfillable.
3. If the stock quantity falls below the re-order threshold a new purchase order should be generated. For the purposes of this exercise, assume that the code for re-ordering already exists, although you may need to create an empty “stub” method to demonstrate.
4. For ease of testing, please provide a simple script that runs your code and shows the result (that we can run from the command line)


### Acceptance Criteria

Stock quantities will be checked to determine if it is possible to fulfil orders, updating the stock quantities upon allocation for order fulfilment and generating purchase orders where the resultant stock quantity is below the stock reorder threshold. 
Since this is just a simple example when an order is fulfilled you only need to decrease the stock on hand and change the order status to Fulfilled.
If an order cannot be fulfilled the order is changed to status “Unfulfillable” to be flagged for review but other orders within the order run are processed. 

### Out of scope

This ticket does not address consignment labelling or shipping requirements. Fulfilling partial orders is not required, if the stock is not available to fulfil an order, then order should not be processed.
We don’t expect your changes to be persisted between runs.


# Post-Implementation Notes

I perhaps naively chose to do this without ActiveModel, so you'll see I had some difficulties managing the Products and Orders I had in memory from other classes. By utilizing class variables for Order and Product classes, I was able to solve this issue and see all the Products in memory with their real values despite there being no database, but it's not pretty and it's not best practise. In a real life scenario I'd seek guidance on how to implement this with ActiveModel, without any of the data persisting to a database.

To get started, instantiate the OrderFulfillment class: 

```
@client = OrderFulfillment.new
```

This will load all the data from the json file. if you reinstantiate this class, it will have a reset database.
so for the sake of this demo, the following script will let you test each order id individually or all at once:

```
@order_ids = @client.get_orders.map &:order_id
@client.process_orders @order_ids

@client.process_orders [@order_ids.sample]
```

