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

import 'dart:html' show ButtonElement, Event;
import 'package:polymer/polymer.dart' show Polymer, Observable, CustomTag, observable, published;

import 'component.dart';
import 'has_action.dart';
import 'has_data.dart';

/**
 * Base class for all Action Buttons. 
 */
@CustomTag('m-button')
class Button extends ButtonElement with Polymer, Observable, Component, HasAction, HasData {
  
  /**************
   * Properties *
   **************/
  
  /**
   * Do action with optional [data].
   */
  @published
  Function doAction;
  
  /**
   * Flag obligates to send data with action.
   */
  @published
  bool sendData = false;
  
  /**
   * Arbitrary information.
   */
  @published
  @observable
  dynamic data;
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Constructor instantiated by the DOM when a Action Button element has been 
   * created.
   */
  Button.created():super.created() {
    addClasses(this, "button");
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
    if (doAction != null) {
      if (sendData) {
        doAction(data);
      } else {
        doAction();
      }
    }
  }
}