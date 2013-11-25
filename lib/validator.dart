// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_validation;

import 'dart:html';

import 'package:polymer/polymer.dart';
import "package:log4dart/log4dart.dart";

import 'component.dart';

/**
 * The component contauns base validation mechanism.
 */
@CustomTag('m-validator')
class Validator extends SpanElement with Polymer, Observable, Component {

  static final _logger = LoggerFactory.getLoggerFor(Validator);
  
  /*************
   * Constants *
   *************/
  
  /**
   *  A String containing the decimal digits 0 through 9.    
   */ 
  static const String DECIMAL_DIGITS = "0123456789";
  
  /**
   * Provider of 'validate' events.
   */
  static const EventStreamProvider<Event> _validateEvent = const EventStreamProvider<Event>(Component.VALIDATE_EVENT);
  
  /**************
   * Properties *
   **************/
  
  /**
   * Reference to element to be validated. Can be any value acceptable by 
   * [querySelector] method.
   */
  @published
  String validate;
  
  /**
   * Property to enable/disable validation process.
   * 
   * Setting this value to false will stop the validator from performing 
   * validation. When a validator is disabled, it dispatches no events, and the 
   * [validate] method returns ValidationEvent.VALID instance.
   */
  @published
  bool enabled = true;
  
  /**
   * If true specifies that a missing or empty value causes a validation error. 
   */
  @published
  bool required = true;
  
  /**
   * Flag managing show or not result of validation as text in [Validator].
   */
  @published
  bool displayResult = true;
  
  /**
   * Error message when a value is missing and the [required] property is true. 
   *  
   * By default equals "This field is required."
   */
  @published
  String requiredError = "This field is required.";
  
  /**
   * Result of validation shows in [Validator] if [displayResult] equals true.
   */
  @published
  ObservableList validationResult = toObservable([]);
  
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'validate' events handled by this element.
   */
  ElementStream<Event> get onValidate => _validateEvent.forElement(this);

  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory Validator() {
    return new Element.tag('span', 'm-validator');
  }
  
  /**
   * Constructor instantiated by the DOM when a Validator element has been created.
   */
  Validator.created():super.created() {
    dataset['validator'] = 'true';
  }
  
  /**
   * Add validation to [validate] element.
   */
  void ready() {
    addValidationTo();
  }
  
  /**
   * Add validation to element referenced by [validate].
   */
  void addValidationTo() {
    _logger.debug('addValidationTo $validate');
    Element element = this.parent.querySelector(validate);
    if (element != null) {
      _logger.debug('addValidationTo as $element');
      element.onBlur.listen(validate_);
      element.onChange.listen(validate_);
      element.onKeyUp.listen(validate_);
    }
  }
  
  /***********
   * Methods *
   ***********/
  
  /**
   * Runs validation process from Form or other external sources.
   */
  bool isValid() {
    Element element = this.parent.querySelector(validate);
    if (element != null) {
      _logger.debug('Check is $element valid');
      return validate_(null);
    }
  }
  
  /**
   * Blur, Change and KeyUp Events handler. Return result of validation.
   */
  bool validate_(Event e) {
    List<String> result = [];
    bool valid = true;
    // Check is element has asseptable type
    //dynamic element = e.target;
    dynamic element = this.parent.querySelector(validate);
    _logger.debug('validate_ is $element');
    if (element is InputElement ||
        element is SelectElement ||
        element is TextAreaElement) {
      dynamic value = element.value;
      _logger.debug('value is $value');
      // Is validation enabled?
      if (enabled) {
        if (required && (value == null || value.toString().length == 0)) {
          // Do 'required' validation
          result.add(requiredError);
          _logger.debug('required $result');
        }
        // Continue validation
        result = doValidate(value, result);
        _logger.debug('required $result');
      }
      // Display validation result
      validationResult = toObservable(result);
      valid = result.length == 0;
    }
    // Dispatch Validation Event.
    dispatchEvent(new CustomEvent(Component.VALIDATE_EVENT, detail:(valid)));
    return valid;
  }
  
  /**
   * This is convinient method to do specifica validation.
   * Developer must overrid [doValidate] rather then [validate] method.
   */
  List<String> doValidate(dynamic value, List<String> results) {
    _logger.debug('doValidate');
    return results;
  }
}

/**
 * Convinient method to substitute string with named parameters. Method find 
 * the parameter [from] in curly brackets and change it [to] value converted to 
 * string.
 */
String substitute(String input, String from, dynamic to) {
  return input.replaceFirst(new RegExp(from), to.toString());
}