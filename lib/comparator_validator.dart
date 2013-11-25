// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_comparator_validation;

import 'dart:html';

import 'package:polymer/polymer.dart';
import "package:log4dart/log4dart.dart";

import 'component.dart';
import 'validator.dart';

/**
 * The StringValidator component validates that the length of a String is within 
 * a specified range between [minLength] and [maxLength].
 */
@CustomTag('m-comparator-validator')
class ComparatorValidator extends Validator with Polymer, Observable, Component {

  static final _logger = LoggerFactory.getLoggerFor(ComparatorValidator);
  
  /**************
   * Properties *
   **************/
  
  /**
   * Reference to element to be compared with [validate] element. 
   * Can be any value acceptable by [querySelector] method.
   */
  @published
  String compareTo;
  
  /** 
   *  Error message when the value of comparable elements not equals. 
   *  "Values not equals."
   */
  @published
  String compareError = "Values not equals.";
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory ComparatorValidator() {
    return new Element.tag('span', 'm-comparator-validator');
  }
  
  /**
   * Constructor instantiated by the DOM when a ComparatorValidator element has been created.
   */
  ComparatorValidator.created():super.created() {
    dataset['validator'] = 'true';
  }
  
  /**
   * Add validation to [validate] element.
   */
  void ready() {
    super.ready();
    addValidationTo();
  }
  
  /**
   * Add validation to element referenced by [validate].
   */
  void addValidationTo() {
    super.addValidationTo();
    Element toCompare = this.parent.querySelector(compareTo);
    if (toCompare != null) {
      _logger.debug('addValidationTo as $toCompare');
      toCompare.onBlur.listen(validate_);
      toCompare.onChange.listen(validate_);
      toCompare.onKeyUp.listen(validate_);
    }
  }
  
  /**
   * Blur, Change and KeyUp Events handler. Return result of validation.
   */
  bool validate_(Event e) {
    List<String> result = [];
    dynamic value, value2;
    // Check is element has asseptable type
    dynamic element = this.parent.querySelector(validate);
    _logger.debug('validate_ is $element');
    if (element is InputElement ||
        element is SelectElement ||
        element is TextAreaElement) {
      value = element.value;
      _logger.debug('value is $value');
    }
    
    dynamic toCompare = this.parent.querySelector(compareTo);
    _logger.debug('validate_ is $toCompare');
    if (toCompare is InputElement ||
        toCompare is SelectElement ||
        toCompare is TextAreaElement) {
      value2 = toCompare.value;
      _logger.debug('value2 is $value2');
    }

    // Is validation enabled?
    if (enabled && value != value2) {
      result.add(compareError);
      _logger.debug('Compare result: $result');
    }
    // Display validation result
    validationResult = toObservable(result);
    bool valid = result.length == 0;
    _logger.debug('Validation result: $valid');
    // Dispatch Validation Event.
    dispatchEvent(new CustomEvent(Component.VALIDATE_EVENT, detail:(valid)));
    return valid;
  }
}