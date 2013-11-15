// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_string_validation;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'component.dart';
import 'validator.dart';

/**
 * The StringValidator component validates that the length of a String is within 
 * a specified range between [minLength] and [maxLength].
 */
@CustomTag('m-string-validator')
class StringValidator extends Validator with Polymer, Observable, Component {

  /**************
   * Properties *
   **************/
  
  /** 
   *  Maximum length for a valid String. A value of null means this property 
   *  is ignored. It is equals null by default.
   */
  @published
  int maxLength;
  
  /** 
   *  Error message when the String is longer than the [maxLength] property. By
   *  default it's equals "This string is longer than the maximum allowed length. 
   *  This must be less than {0} characters long."
   */
  @published
  String tooLongError = "This string is longer than the maximum allowed length. This must be less than {maxLength} characters long.";
  
  /** 
   *  Minimum length for a valid String. A value of NaN means this property 
   *  is ignored. It is equals null by default.
   */
  @published
  int minLength;
  
  /** 
   *  Error message when the string is shorter than the [minLength] property. By
   *  default it's equals "This string is shorter than the minimum allowed length. 
   *  This must be at least {0} characters long."
   */
  @published
  String tooShortError =  "This string is shorter than the minimum allowed length. This must be at least {minLength} characters long.";
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory StringValidator() {
    return new Element.tag('div', 'm-string-validator');
  }
  
  /**
   * Constructor instantiated by the DOM when a StringValidator element has been created.
   */
  StringValidator.created():super.created();
  
  /**
   * Add validation to [validate] element.
   */
  void ready() {
    print('ready');
    //
    addValidationTo();
  }
  
  /***********
   * Methods *
   ***********/
  
  /**
   * This is convinient method to do specifica validation.
   * Developer must overrid [doValidate] rather then [validate] method.
   */
  @override
  List<String> doValidate(String value, List<String> results) {
    List<String> res = super.doValidate(value, results);
    print('String.doValidate $res');
    // Return if there are errors or if the required property is set to false 
    // and length is 0.
    String val = value == null ? "" : value;
    
    if (res.length > 0 || ((val.length == 0) && !required)) {
      print('Back because is required');
      return res;
    } else {
      return _validateString(val);
    }
  }
  
  /**
   * Validate [value] and  return List of error messages, with one
   * item for each field examined by the validator.
   */
  List<String> _validateString(String value) {
    print('_validateString');
    List<String> results = [];
    
    if (maxLength != null && value.length > maxLength) {
      results.add(substitute(tooLongError, '{maxLength}', maxLength));
    } else if (minLength != null && value.length < minLength) {
      results.add(substitute(tooShortError, '{minLength}', minLength));
    }
    print('_validateString $results');
    return results;
  }
}