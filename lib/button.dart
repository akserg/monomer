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

library monomer_button;

import 'dart:html' show ButtonElement, Event, EventStreamProvider, ElementStream, CustomEvent;
import 'package:polymer/polymer.dart' show Polymer, Observable, CustomTag, observable, published;

import 'src/component.dart';
import 'src/has_action.dart';
import 'src/has_data.dart';

/**
 * Base class for all Action Buttons. 
 */
@CustomTag('m-button')
class Button extends ButtonElement with Polymer, Observable, Component, HasAction, HasData {
  
  /*************
   * Constants *
   *************/
  
  /**
   * Provider of 'action' events.
   */
  static const EventStreamProvider<Event> _actionEvent = const EventStreamProvider<Event>('action');
  
  /**************
   * Properties *
   **************/
  
  bool get applyAuthorStyles => true;
  
  /**
   * Arbitrary information stored in Button.
   */
  @published
  @observable
  dynamic data;
  
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'action' events handled by this Button.
   */
  ElementStream<Event> get onAction => _actionEvent.forElement(this);
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Constructor instantiated by the DOM when a Action Button element has been 
   * created.
   */
  Button.created():super.created() {
    // Listen click event to do the action
    onClick.listen(onClickHandler);
  }

  /***********
   * Methods *
   ***********/
  
  /**
   * Click handler to do the action with optional data.
   * This method prevents 'click' event dispatching further.
   */
  void onClickHandler(Event e) {
    cancelEvent(e);
    dispatchEvent(new CustomEvent('action', detail:data));
  }
}