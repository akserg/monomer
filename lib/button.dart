// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_button;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import "package:log4dart/log4dart.dart";

import 'item_renderer.dart';
import 'component.dart';

/**
 * Base class for all Action Buttons. 
 */
@CustomTag('m-button')
class Button extends ButtonElement with Polymer, Observable, Component implements ItemRenderer {
  
  static final _logger = LoggerFactory.getLoggerFor(Button);
  
  /*************
   * Constants *
   *************/
  
  /**
   * Provider of 'action' events.
   */
  static const EventStreamProvider<Event> _actionEvent = const EventStreamProvider<Event>(Component.ACTION_EVENT);
  
  /**
   * Provider of 'visible' events.
   */
  static const EventStreamProvider<Event> _visibleEvent = const EventStreamProvider<Event>(Component.VISIBLE_EVENT);
  
  /**
   * Provider of 'includeInLayout' events.
   */
  static const EventStreamProvider<Event> _includeInLayoutEvent = const EventStreamProvider<Event>(Component.INCLUDE_IN_LAYOUT_EVENT);
  
  /**
   * Provider of 'change' events.
   */
  static const EventStreamProvider<Event> _changeEvent = const EventStreamProvider<Event>(Component.CHANGE_EVENT);
  
  /**
   * Provider of 'dataChange' events.
   */
  static const EventStreamProvider<Event> _dataChangeEvent = const EventStreamProvider<Event>(Component.DATA_CHANGE_EVENT);
  
  /**************
   * Properties *
   **************/
  
  bool get applyAuthorStyles => true;
  
  /**
   * The data to render or edit.
   */
  @published
  dynamic data;
  dataChanged(old) {
    _logger.debug('data changed $old to $data');
    dispatchEvent(new CustomEvent(Component.DATA_CHANGE_EVENT, detail:data));
  }
  
  /**
   * The String to display in the item renderer. 
   * The host component of the item renderer can use the [itemToLabel] method 
   * to convert the data item to a String for display by the item renderer.
   */
  @published
  String label;
  
  /**
   * Will equals true if rendering item is selected.
   */
  @published
  bool itemSelected = false;
  itemSelectedChanged(old) {
    _logger.debug('itemSelected is $itemSelected');
    dispatchEvent(new CustomEvent(Component.CHANGE_EVENT, detail:itemSelected));
  }
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'action' events handled by this element.
   */
  ElementStream<Event> get onAction => _actionEvent.forElement(this);
  
  /**
   * Stream of 'visible' events handled by this element.
   */
  ElementStream<Event> get onVisible => _visibleEvent.forElement(this);
  
  /**
   * Stream of 'includeInLayout' events handled by this element.
   */
  ElementStream<Event> get onIncludeInLayout => _includeInLayoutEvent.forElement(this);
  
  /**
   * Stream of 'change' events handled by this element.
   */
  ElementStream<Event> get onChange => _changeEvent.forElement(this);
  
  /**
   * Stream of 'dataChange' events handled by this element.
   */
  ElementStream<Event> get onDataChange => _dataChangeEvent.forElement(this);
  
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
    // Add double way binding to 'checked' property of button to 'itemSelected'
    nodeBind(this).bind('checked', this, 'itemSelected');
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
    _logger.debug("Action on Button with $data");
    itemSelected = !itemSelected;
    dispatchEvent(new CustomEvent(Component.ACTION_EVENT, detail:data));
  }
}