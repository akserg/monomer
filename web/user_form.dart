// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library example_order_form;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart';
import 'package:monomer/component.dart';
import 'package:monomer/transformer.dart';
import "package:log4dart/log4dart.dart";

import 'user.dart';

@CustomTag('e-user-form')
class UserForm extends DivElement with Polymer, Observable, Component {

  static final _logger = LoggerFactory.getLoggerFor(UserForm);
  
  /*************
   * Properties
   ************/
  
  bool get applyAuthorStyles => true;
  
  @observable
  User user;
  
  /**
   * ToInt transformer
   */
  final Transformer toInt = new ToInt();

  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory UserForm() {
    return new Element.tag('div', 'e-user-form');
  }
  
  /**
   * Constructor instantiated by the DOM when a UserForm has been 
   * created.
   */
  UserForm.created():super.created();
  
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
    user = new User(1, 
        name:'John',
        lastName:'Smith',
        age:30,
        email:'john.smith@gmail.com'
      );
  }
  
  /**
   * Action EVent handler.
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
}

