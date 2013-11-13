// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_button;

import 'dart:html';
import 'package:polymer/polymer.dart';

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
  
  static const String ACTION_EVENT = 'action';
  
  /**
   * Provider of 'action' events.
   */
  static const EventStreamProvider<Event> _actionEvent = const EventStreamProvider<Event>(ACTION_EVENT);
  
  /**
   * Provider of 'visible' events.
   */
  static const EventStreamProvider<Event> _visibleEvent = const EventStreamProvider<Event>(Component.VISIBLE_EVENT);
  
  /**
   * Provider of 'includeInLayout' events.
   */
  static const EventStreamProvider<Event> _includeInLayoutEvent = const EventStreamProvider<Event>(Component.INCLUDE_IN_LAYOUT_EVENT);
  
  /**************
   * Properties *
   **************/
  
  bool get applyAuthorStyles => true;
  
  /**
   * Arbitrary information stored in Button.
   */
  @published
  dynamic data;
  
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'action' events handled by this Button.
   */
  ElementStream<Event> get onAction => _actionEvent.forElement(this);
  
  /**
   * Stream of 'visible' events handled by this Button.
   */
  ElementStream<Event> get onVisible => _visibleEvent.forElement(this);
  
  /**
   * Stream of 'includeInLayout' events handled by this Button.
   */
  ElementStream<Event> get onIncludeInLayout => _includeInLayoutEvent.forElement(this);
  
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory Button() {
    return new Element.tag('button', 'm-button');
  }
  
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
    dispatchEvent(new CustomEvent(ACTION_EVENT, detail:data));
  }
}