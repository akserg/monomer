// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library example_gender_select;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:monomer/component.dart';
import "package:log4dart/log4dart.dart";

@CustomTag('e-gender-select')
class GenderSelect extends DivElement with Polymer, Observable, Component {

  static final _logger = LoggerFactory.getLoggerFor(GenderSelect);
  
  /*************
   * Properties
   ************/
  
  bool get applyAuthorStyles => true;
  
  @observable
  ObservableList genders = toObservable(
      [{'label':'Male','value':'male'}, 
       {'label':'Female', 'value':'femail'}]);

  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory GenderSelect() {
    return new Element.tag('div', 'e-gender-select');
  }
  
  /**
   * Constructor instantiated by the DOM when a GenderSelect has been 
   * created.
   */
  GenderSelect.created():super.created();
  
  /***********
   * Methods *
   ***********/
  
  /**
   * Action Event handler.
   */
  void onAction(CustomEvent event) {
    _logger.debug('action ${event.target}. Data is: ${event.detail}');
    if (event.target is Component) {
      _logger.debug('Data is ${(event.target as Component).data}');
    }
  }
  
  /**
   * Fault Event handler.
   */
  void onFault(CustomEvent event) {
    _logger.error('fault ${event.target}: ${event.detail}');
  }
  
  /******************
   * Event Handlers *
   ******************/
  
  void onGenderSelected(CustomEvent event) {
    _logger.debug('Gender selected: ${event.detail}');
  }
}

