// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_form_field;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'component.dart';

/**
 * A FormItem component is container for form items. It consisting of a single label and one or more child elements, such as input elements 
 */
@CustomTag('m-form-field')
class FormField extends DivElement with Polymer, Observable, Component {
  
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
  
  /**************
   * Properties *
   **************/
  
  bool get applyAuthorStyles => true;
  
  /**
   * Arbitrary information stored in FormField.
   */
  @published
  dynamic data;
  
  /**
   * Form Field label. TODO: Necessity?
   */
  @published
  String label;
  
  /**
   * Field name
   */
  @published
  String field;
  
  /**
   * Is field visible
   */
  @published
  bool fieldVisible = true;
  
  /**
   * Required flag of field
   */
  @published
  bool required = false;
  
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
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory FormField() {
    return new Element.tag('div', 'm-form-field');
  }
  
  /**
   * Constructor instantiated by the DOM when a FormField element has been created.
   */
  FormField.created():super.created();
}
