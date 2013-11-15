// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void numberValidatorTests() {
  logMessage('Performing Number validator tests.');

  group('Testing Number validator:', () {
    NumberValidator validator;
    InputElement input;
    
    setUp((){
      input = new Element.tag('input');
      input.type = "text";
      input.id = "input2";
      document.body.append(input);
      validator = new NumberValidator();
      validator.validate = "#input2";
      validator.minValue = 2;
      validator.maxValue = 50;
      document.body.append(validator);
    });
    
    tearDown((){
      validator.remove();
    });
    
    test('Check Required', () {
      logMessage('Expect handle required event when input is empty');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      logMessage('Add value');
      input.text = "12";
    });
    
    test('Check minValue', () {
      logMessage('Expect handle error messages when input has less value then specified in minValue');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The number entered is too small."));
      });
      
      logMessage('Add less value');
      input.text = "1";
    });
    
    test('Check maxValue', () {
      logMessage('Expect handle error message when input has more value then specified in maxValue');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The number entered is too large."));
      });
      
      logMessage('Add more value');
      input.text = "123456";
    });
    
    test('Check In Boundary', () {
      logMessage('Expect handle required event when input has correct value');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      logMessage('Add exact number');
      input.text = "12";
    });
    
    test('Check not allow Negative', () {
      logMessage('Expect handle error message when input has not alowed negative value');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The number may not be negative."));
      });
      
      logMessage('Add negative value');
      input.text = "-20";
    });
    
    test('Check allow Negative', () {
      logMessage('Expect handle error message when input has alowed negative value');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult.length, equals(0));
      });
      
      validator.allowNegative = true;
      logMessage('Add negative value');
      input.text = "-20";
    });
    
    test('Check more then one decimal separator', () {
      logMessage('Expect handle error message when input has more then one decimal separator');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The decimal separator can only occur once."));
      });
      
      logMessage('Add value with two decimal points');
      input.text = "20.20.3";
    });
    
    test('Check invalid characters', () {
      logMessage('Expect handle error message when input has invalid characters');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The input contains invalid characters."));
      });
      
      logMessage('Add value with two decimal points');
      input.text = "20as";
    });
    
    test('Check integer', () {
      logMessage('Expect handle error message when input is integer and has decimal point');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The number must be an integer."));
      });
      
      validator.domain = NumberValidator.INTEGER;
      logMessage('Add value with decimal point to integer');
      input.text = "20.1";
    });
  });
}