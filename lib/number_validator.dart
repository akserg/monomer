// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_number_validation;

import 'dart:html';

import 'package:polymer/polymer.dart';
import "package:log4dart/log4dart.dart";

import 'component.dart';
import 'validator.dart';

/**
 * The NumberValidator component ensures that a String represents a valid number.
 * It can ensure that the input falls:
 * - within a given range (specified by [minValue] and [maxValue]),
 * - is an integer (specified by [domain]),
 * - is non-negative (specified by [allowNegative]),
 * - does not exceed the specified [precision].
 * 
 * The validator correctly validates formatted numbers (e.g., "12,345.67")
 * and you can customize the [thousandsSeparator] and
 * [decimalSeparator] properties for internationalization.
 */
@CustomTag('m-number-validator')
class NumberValidator extends Validator with Polymer, Observable, Component {
  
  static final _logger = LoggerFactory.getLoggerFor(NumberValidator);
  
  /*************
   * Constants *
   *************/
  
  static const String INTEGER = "integer";
  static const String DOUBLE = "double";

  /**************
   * Properties *
   **************/
  
  /**
   * Specifies whether negative numbers are permitted.
   * Allowed by default.
   */
  @published
  bool allowNegative = true;
  
  /**
   * The character used to separate the whole from the fractional part of the 
   * number. Cannot be a digit and must be distinct from the [thousandsSeparator].
   * By default equals "."
   */
  @published
  String decimalSeparator = ".";
  
  /**
   * Type of number to be validated. 
   * Permitted values are [NumberValidator.INTEGER] and [NumberValidator.DOUBLE].
   * By default equals [NumberValidator.DOUBLE].
   */
  @published
  String domain = NumberValidator.DOUBLE;
  
  /**
   * Maximum value for a valid number. A value of null means there is no maximum.
   */
  @published
  num maxValue;
  
  /**
   * Minimum value for a valid number. A value of null means there is no minimum.
   */
  @published
  num minValue;
  
  /**
   * The maximum number of digits allowed to follow the decimal point.
   * Can be any nonnegative integer.
   */
  @published
  int precision;
  
  /**
   * The character used to separate thousands in the whole part of the number.
   * Cannot be a digit and must be distinct from the [decimalSeparator].
   */
  @published
  String thousandsSeparator = ",";
  
  /**
   * Error message when the decimal separator character occurs more than once.
   * By default equals "The decimal separator can occur only once."
   */
  @published
  String decimalPointCountError = "The decimal separator can only occur once.";
  
  /**
   * Error message when the value exceeds the [maxValue] property.
   * By default equals "The number entered is too large then maximum value {maxValue}."
   */
  @published
  String exceedsMaxError = "The number entered is too large then maximum value {maxValue}.";
  
  /**
   * Error message when the number must be an integer, as defined by the 
   * [domain] property.
   * By default it's equals "The number must be an integer." 
   */
  @published
  String integerError = "The number must be an integer.";
  
  /**
   * Error message when the value contains invalid characters.
   *
   * By default it equals "The input contains invalid characters."
   */
  @published
  String invalidCharError = "The input contains invalid characters.";
      
  /**
   * Error message when the value contains invalid format characters, which 
   * means that it contains a digit or minus sign (-) as a separator character, 
   * or it contains two or more consecutive separator characters.
   *
   * By default it equals "One of the formatting parameters is invalid."
   */
  @published
  String invalidFormatCharsError = "One of the formatting parameters is invalid.";
  
  /**
   * Error message when the value is less than [minValue].
   *
   * By default it equals "The number entered is too small then minimum value {minValue}."
   */
  @published
  String lowerThanMinError = "The number entered is too small then minimum value {minValue}.";
  
  /**
   * Error message when the value is negative and the [allowNegative] 
   * property is [false].
   *
   * By default it equals "The number may not be negative."
   */
  @published
  String negativeError = "The number may not be negative.";
  
  /**
   * Error message when the value has a precision that exceeds the value defined 
   *  by the precision property.
   *
   *  By "default" it equals "The number entered has too many digits beyond the decimal point {precision}."
   */
  @published
  String precisionError = "The number entered has too many digits beyond the decimal point {precision}.";
  
  /**
   * Error message when the thousands separator is in the wrong location.
   *
   * By default it equals "The thousands separator must be followed by three digits."
   */
  @published
  String separationError = "The thousands separator must be followed by three digits.";
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory NumberValidator() {
    return new Element.tag('span', 'm-number-validator');
  }
  
  /**
   * Constructor instantiated by the DOM when a NumberValidator element has been created.
   */
  NumberValidator.created():super.created();
  
  
  /**
   * Add validation to [validate] element.
   */
  void ready() {
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
  List<String> doValidate(dynamic value, List<String> results) {
    List<String> res = super.doValidate(value, results);
    _logger.debug('Number.doValidate $res');
    // Return if there are errors or if the required property is set to false 
    // and length is 0.
    String val = value == null ? "" : value.toString();
    
    if (res.length > 0 || ((val.length == 0) && !required)) {
      _logger.debug('Back because is required');
      return res;
    } else {
      return _validateNumber(val);
    }
  }
  
  /**
   * Validate [value] and  return List of error messages, with one
   * item for each field examined by the validator.
   */
  List<String> _validateNumber(String value) {
    _logger.debug('_validateNumber $value');
    List<String> results = [];
    
    int len = value.length;

    bool isNegative = false;
    
    int i;
    String c;

    // Make sure the formatting character parameters are unique,
    // are not digits or the negative sign,
    // and that the separators are one character.
    String invalidFormChars = Validator.DECIMAL_DIGITS + "-";
        
    if (decimalSeparator == thousandsSeparator ||
        invalidFormChars.indexOf(decimalSeparator) != -1 ||
        invalidFormChars.indexOf(thousandsSeparator) != -1 ||
        decimalSeparator.length != 1 ||
        thousandsSeparator.length != 1) {
      results.add(invalidFormatCharsError);
      return results;
    }
    
    // Check for invalid characters in value.
    String validChars = Validator.DECIMAL_DIGITS + "-" + decimalSeparator + thousandsSeparator;
    for (i = 0; i < len; i++) {
      c = value[i];
      if (validChars.indexOf(c) == -1) {
        results.add(invalidCharError);
        return results;
      }
    }
    
    // Check if the value is negative.
    if (value[0] == "-") {
      if (len == 1) {
        // we have only '-' char
        results.add(invalidCharError);
        return results;
      } else if (len == 2 && value[1] == '.') {
        // handle "-."
        results.add(invalidCharError);
        return results;
      }

      // Check if negative value is allowed.
      if (!allowNegative) {
        results.add(negativeError);
        return results;
      }

      // Strip off the minus sign, update some variables.
      value = value.substring(1);
      len--;
      isNegative = true;
    }
    
    // Make sure there's only one decimal point.
    if (value.indexOf(decimalSeparator) != value.lastIndexOf(decimalSeparator)) {
      results.add(decimalPointCountError);
      return results;
    }
    
    // Make sure every character after the decimal is a digit,
    // and that there aren't too many digits after the decimal point:
    // if domain is int there should be none,
    // otherwise there should be no more than specified by precision.
    int decimalSeparatorIndex = value.indexOf(decimalSeparator);
    if (decimalSeparatorIndex != -1) {
      int numDigitsAfterDecimal = 0;

      if (i == 1 && i == len) {
        // we only have a '.'
        results.add(invalidCharError);
        return results;
      }
      
      for (i = decimalSeparatorIndex + 1; i < len; i++) {
        // This character must be a digit.
        if (Validator.DECIMAL_DIGITS.indexOf(value[i]) == -1) {
          results.add(invalidCharError);
          return results;
        }

        ++numDigitsAfterDecimal;

        // There may not be any non-zero digits after the decimal
        // if domain is int.
        if (domain == NumberValidator.INTEGER && value[i] != "0") {
          results.add(integerError);
          return results;
        }

        // Make sure precision is not exceeded.
        if (precision != -1 && numDigitsAfterDecimal > precision) {
          results.add(substitute(precisionError, '{precision}', precision));
          return results;
        }
      }
    }
    
    // Make sure the value begins with a digit or a decimal point.
    if (Validator.DECIMAL_DIGITS.indexOf(value[0]) == -1 && value[0] != decimalSeparator) {
      results.add(invalidCharError);
      return results;
    }
    
    // Make sure that every character before the decimal point
    // is a digit or is a thousands separator.
    // If it's a thousands separator,
    // make sure it's followed by three consecutive digits.
    int end = decimalSeparatorIndex == -1 ? len : decimalSeparatorIndex;
    for (i = 1; i < end; i++) {
      c = value[i];
      if (c == thousandsSeparator) {
        if (c == thousandsSeparator) {
          if ((end - i != 4 &&
              value[i + 4] != thousandsSeparator) ||
              Validator.DECIMAL_DIGITS.indexOf(value[i + 1]) == -1 ||
              Validator.DECIMAL_DIGITS.indexOf(value[i + 2]) == -1 ||
              Validator.DECIMAL_DIGITS.indexOf(value[i + 3]) == -1) {
            results.add(separationError);
            return results;
          }
        }
      } else if (Validator.DECIMAL_DIGITS.indexOf(c) == -1) {
        results.add(invalidCharError);
        return results;
      }
    }
    
    // Make sure the value is within the specified range.
    if (minValue != null || maxValue != null) {
      // First strip off the thousands separators.
      for (i = 0; i < end; i++) {
        if (value[i] == thousandsSeparator) {
          String left = value.substring(0, i);
          String right = value.substring(i + 1);
          value = left + right;
        }
      }

      // Translate the value back into standard english
      // If the decimalSeperator is not '.' we need to change it to '.' 
      // so that the number casting will work properly
      if (decimalSeparator != '.') {
        int dIndex = value.indexOf(decimalSeparator);
        if (dIndex != -1) { 
          String dLeft = value.substring(0, dIndex);
          String dRight = value.substring(dIndex + 1);
          value = dLeft + '.' + dRight;
        }
      }

      // Check bounds
      double x = double.parse(value, (String source) => 0.0);

      if (isNegative)
          x = -x;

      if (minValue != null && x < minValue) {
        results.add(substitute(lowerThanMinError, '{minValue}', minValue));
        return results;
      }
            
      if (maxValue != null && x > maxValue) {
        results.add(substitute(exceedsMaxError, '{maxValue}', maxValue));
        return results;
      }
    }
    _logger.debug('_validateNumber $results');
    return results;
  }
}