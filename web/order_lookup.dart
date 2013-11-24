// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library example_order_lookup;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:monomer/component.dart';

@CustomTag('e-order-lookup')
class OrderLookup extends DivElement with Polymer, Observable, Component {

  /*************
   * Properties
   ************/
  
  bool get applyAuthorStyles => true;
  
  @observable
  ObservableList countryItems = toObservable([]);

  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory OrderLookup() {
    return new Element.tag('div', 'e-order-lookup');
  }
  
  /**
   * Constructor instantiated by the DOM when a OrderLookup has been 
   * created.
   */
  OrderLookup.created():super.created();
  
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
    //
    List items = toObservable([]);
    for (int i = 0; i < 3; i++) {
      items.add({'label':'N$i', 'value':'$i'});
    }
    countryItems = items;
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
  
  /******************
   * Event Handlers *
   ******************/
  
  void onContrySelected(CustomEvent event) {
    print('SelectedCoutries changed: ${event.detail}');
  }
}

