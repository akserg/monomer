// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void stringValidatorTests() {
  logMessage('Performing String validator tests.');

  group('Testing String validator:', () {
    StringValidator validator;
    InputElement input;
    
    setUp((){
      input = new Element.tag('input');
      input.type = "text";
      input.id = "input2";
      document.body.append(input);
      validator = new StringValidator();
      validator.validate = "#input2";
      validator.minLength = 2;
      validator.maxLength = 5;
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
      
      logMessage('Add the text to input');
      input.text = "12";
    });
    
    test('Check MinLength', () {
      logMessage('Expect handle error messages when input has less characters then specified in minLength');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("This string is shorter than the minimum allowed length. This must be at least ${validator.minLength} characters long."));
      });
      
      logMessage('Add less chars then expect');
      input.text = "1";
    });
    
    test('Check MaxLength', () {
      logMessage('Expect handle error message when input has more characters then specified in maxLength');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("This string is longer than the maximum allowed length. This must be less than ${validator.maxLength} characters long."));
      });
      
      logMessage('Add more chars then expect');
      input.text = "123456";
    });
    
    test('Check In Boundary', () {
      logMessage('Expect handle required event when input has correct number of characters');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      logMessage('Add exact number of chars');
      input.text = "123";
    });
  });
}