// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library example_order;

/*
 * This is Order from order list.
 */
class Order {
  
  /**
   * Order id.
   */
  int id;
  
  /**
   * Order name.
   */
  String name;
  
  /**
   * Create an instance of Order.
   */
  Order([this.id, this.name]);
  
  /**
   * Convert Order to JSON String
   */
  String toJson() {
    return "{id:$id, name:$name}";
  }
}
