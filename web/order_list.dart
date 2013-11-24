// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library example_order_list;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:monomer/component.dart';

import 'order.dart';

@CustomTag('e-order-list')
class OrderList extends DivElement with Polymer, Observable, Component {

	/*************
   * Properties
   ************/
  
  bool get applyAuthorStyles => true;
  
  @observable
  ObservableList orderItems;

  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory OrderList() {
    return new Element.tag('div', 'e-order-list');
  }
  
  /**
   * Constructor instantiated by the DOM when a OrderList has been 
   * created.
   */
  OrderList.created():super.created();
  
  void ready() {
    callLater(loadData);
  }
  
  /***********
   * Methods *
   ***********/
  
  /**
   * Immitation of loading data.
   */
  void loadData() {
    List items = toObservable([]);
    for (int i = 0; i < 5; i++) {
      items.add(new Order(i, "Order N$i"));
    }
    orderItems = items;
  }
  
  /**
   * Action Event handler.
   */
  void onAction(CustomEvent event) {
    print('action ${event.target}. Data is: ${event.detail}');
    if (event.target is Component) {
      print('Data is ${(event.target as Component).data}');
    }
  }
  
  /**
   * Fault Event handler.
   */
  void onFault(CustomEvent event) {
    print('fault ${event.target}: ${event.detail}');
  }
}

