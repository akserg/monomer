// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void validatorTests() {
  logMessage('Performing validator tests.');

  group('Testing validator:', () {
    Validator validator;
    InputElement input;
    
    setUp((){
      input = new Element.tag('input');
      input.type = "text";
      input.id = "input2";
      document.body.append(input);
      validator = new Validator();
      validator.validate = "#input2";
      document.body.append(validator);
    });
    
    tearDown((){
      validator.remove();
    });
    
    test('Check Not Empty Required', () {
      logMessage('Expect handle required event when input is not empty');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      logMessage('Add text to input');
      input.text = "12";
    });
    
    test('Check Empty Required', () {
      logMessage('Expect handle required event when input is empty');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("This field is required."));
      });
      
      validator.enabled = false;
      logMessage('Add text to input');
      input.text = "123";
      
      validator.enabled = true;
      logMessage('Remove text from input');
      input.text = "";
    });
    
    test('Check No Required', () {
      logMessage('Expect handle validate event when input is not empty');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      logMessage('Add text to input');
      input.text = "12";
      logMessage('Remove text from input');
      input.text = "";
    });
  });
}