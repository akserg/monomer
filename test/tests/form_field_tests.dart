// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void formFieldTests() {
  logMessage('Performing formField tests.');

  group('Testing formField:', () {
    FormField formField;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      formField = new FormField();
      document.body.append(formField);
    });
    
    tearDown((){
      formField.remove();
    });
    
    test('Do Visible', () {
      logMessage('Expect make formField visible or invisible');
      
      formField.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(formField.style.display, equals(''), reason:'must be visible');
        } else {
          expect(formField.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set formField invisible');
      Component.setVisible(formField, false);
      logMessage('Set formField visible');
      Component.setVisible(formField, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude formField from layout');
      
      formField.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(formField.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(formField.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude formField from layout');
      Component.setIncludeInLayout(formField, false);
      logMessage('Include formField in layout');
      Component.setIncludeInLayout(formField, true);
    });
  });
}