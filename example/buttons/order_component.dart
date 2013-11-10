/**
 * Copyright (C) 2013 Sergey Akopkokhyants. All rights reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library example_order_component;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:monomer/src/component.dart';
import 'package:monomer/src/has_data.dart';

import 'order.dart';

@CustomTag('e-order')
class OrderComponent extends DivElement with Polymer, Observable, Component {

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
   * Constructor instantiated by the DOM when a OrderComponent has been 
   * created.
   */
  OrderComponent.created():super.created();
  
  void ready() {
    super.ready();
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
   * Action EVent handler.
   */
  void onAction(CustomEvent event) {
    print('action ${event.target}. Data is: ${event.detail}');
    if (event.target is HasData) {
      print('Data is ${(event.target as HasData).data}');
    }
  }
  
  /**
   * Success EVent handler.
   */
  void onSuccess(CustomEvent event) {
    print('success ${event.target}: ${event.detail}');
    if (event.target is HasData) {
      print('Data is ${(event.target as HasData).data}');
    }
  }
  
  /**
   * Fault Event handler.
   */
  void onFault(CustomEvent event) {
    print('fault ${event.target}: ${event.detail}');
  }
}

