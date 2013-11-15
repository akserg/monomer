// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void regexpValidatorTests() {
  logMessage('Performing RegExp validator tests.');

  group('Testing RegExp validator:', () {
    RegExpValidator validator;
    InputElement input;
    
    setUp((){
      input = new Element.tag('input');
      input.type = "text";
      input.id = "input2";
      document.body.append(input);
      validator = new RegExpValidator();
      validator.validate = "#input2";
      validator.expression = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'; 
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
      
      logMessage('Add and clean text on input');
      input.text = "12";
      input.text = "";
    });
    
    test('Check wrong value', () {
      logMessage('Expect handle required event when input is wrong value');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The field is invalid."));
      });
      
      logMessage('Add wrong text on input');
      input.text = "as@";
    });
    
    test('Check right value', () {
      logMessage('Expect handle required event when input is right value');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      logMessage('Add right text on input');
      input.text = "as@as.com";
    });
    
    test('Check empty expression', () {
      logMessage('Expect handle required event when expression empty');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("The expression is missing."));
      });
      
      validator.expression = "";
      logMessage('Add right text on input');
      input.text = "as@as.com";
    });
    
  });
}