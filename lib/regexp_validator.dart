// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_regexp_validation;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'component.dart';
import 'validator.dart';

/**
 * The StringValidator component validates that the length of a String is within 
 * a specified range between [minLength] and [maxLength].
 */
@CustomTag('m-regexp-validator')
class RegExpValidator extends Validator with Polymer, Observable, Component {

  /**************
   * Properties *
   **************/
  
  /** 
   *  The regular expression to use for validation.
   */
  @published
  String expression;
  expressionChanged(old) {
    _createRegExp();
  }
  
  
  /**
   * The regular expression multiLine flag to use when matching.
   */
  @published
  bool multiLine = false;
  multiLineChanged(old) {
    _createRegExp();
  }
  
  /**
   * The regular expression caseSensitive flag to use when matching.
   */
  @published
  bool caseSensitive = true;
  caseSensitiveChanged(old) {
    _createRegExp();
  }
  
  /**
   * Error message when there is no regular expression specifed. 
   * By default value is "The expression is missing."
   */
  @published
  String noExpressionError = "The expression is missing.";
  
  /**
   * Error message when there are no matches to the regular expression. 
   * By default value is "The field is invalid."
   */
  @published
  String noMatchError = "The field is invalid.";
  
  /**
   * Instance of RegExp using to finding matches.
   */
  RegExp _regExp;
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory RegExpValidator() {
    return new Element.tag('span', 'm-regexp-validator');
  }
  
  /**
   * Constructor instantiated by the DOM when a RegExpValidator element has been created.
   */
  RegExpValidator.created():super.created();
  
  /**
   * Add validation to [validate] element.
   */
  void ready() {
    print('ready');
    //
    addValidationTo();
  }
  
  
  /**
   * Create RegExp as combination of [expression], [multiLine] and [caseSensitive].
   */
  RegExp _createRegExp() {
    if (expression != null) {
      _regExp = new RegExp(expression, multiLine:multiLine, caseSensitive:caseSensitive);
    }
  }
  
  /***********
   * Methods *
   ***********/
  
  /**
   * This is convinient method to do specifica validation.
   * Developer must overrid [doValidate] rather then [validate] method.
   */
  @override
  List<String> doValidate(dynamic value, List<String> results) {
    List<String> res = super.doValidate(value, results);
    print('String.doValidate $res');
    // Return if there are errors or if the required property is set to false 
    // and length is 0.
    String val = value == null ? "" : value.toString();
    
    if (res.length > 0 || ((val.length == 0) && !required)) {
      print('Back because is required');
      return res;
    } else {
      return _validateRegExpression(val);
    }
  }
  
  /**
   * Validate [value] and  return List of error messages, with one
   * item for each field examined by the validator.
   */
  List<String> _validateRegExpression(String value) {
    List<String> results = [];
    
    if (_regExp != null && expression != "") {
      if (!_regExp.hasMatch(value)) {
        results.add(noMatchError);
      }
    } else {
      results.add(noExpressionError);
    }
    
    return results;
  }
}