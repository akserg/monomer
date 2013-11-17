// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void comparatorValidatorTests() {
  logMessage('Performing Comparator validator tests.');

  group('Testing Comparator validator:', () {
    ComparatorValidator validator;
    InputElement input, input2;
    
    setUp((){
      input = new Element.tag('input');
      input.type = "text";
      input.id = "input1";
      document.body.append(input);
      //
      input2 = new Element.tag('input');
      input2.type = "text";
      input2.id = "input2";
      document.body.append(input2);
      //
      validator = new ComparatorValidator();
      validator.validate = "#input1";
      validator.compare = "#input2";
      document.body.append(validator);
    });
    
    tearDown((){
      validator.remove();
    });
    
    test('Check compare  equals', () {
      logMessage('Expect handle compare event when input1 value the same as input2');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isTrue);
        expect(validator.validationResult.length, equals(0));
      });
      
      validator.enabled = false;
      logMessage('Add the same text to both input');
      input.text = "12";
      validator.enabled = true;
      input.text = "12";
    });
    
    test('Check compare not equals values', () {
      logMessage('Expect handle compare event when input1 value is not the same as input2');
      
      validator.onValidate.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('validate'), reason:'must be validate event type');
        expect(event.detail, isFalse);
        expect(validator.validationResult.length, equals(1));
        expect(validator.validationResult[0], equals("Values not equals."));
      });
      
      validator.enabled = false;
      logMessage('Add not the same text to both input');
      input.text = "12";
      validator.enabled = true;
      input.text = "123";
    });
  });
}