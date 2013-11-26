// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_radiobutton;

import 'dart:html';

import 'package:polymer/polymer.dart';
import "package:log4dart/log4dart.dart";

import 'item_renderer.dart';
import 'component.dart';

/**
 * The RadioButton component.
 * The RadioButton class can be used as item renderer. 
 * By default, the item renderer draws the radiobutton and text associated with each 
 * item in the list.
 * 
 * You can override the default item renderer by creating a custom item renderer.
 */
@CustomTag('m-radiobutton')
class RadioButton extends SpanElement with Polymer, Observable, Component implements ItemRenderer {
  
  static final _logger = LoggerFactory.getLoggerFor(RadioButton);
  
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
  
  /**
   * Return reference on input element.
   */
  InputElement get input => this.querySelector("#radiobutton");
  
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
  factory RadioButton() {
    return new Element.tag('span', 'm-radiobutton');
  }
  
  /**
   * Constructor instantiated by the DOM when a RadioButton element has 
   * been created.
   */
  RadioButton.created() : super.created();
}