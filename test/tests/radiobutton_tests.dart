// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void radioButtonTests() {
  logMessage('Performing radiobutton tests.');

  group('Testing radiobutton:', () {
    RadioButton radiobutton;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      radiobutton = new RadioButton();
      document.body.append(radiobutton);
    });
    
    tearDown((){
      radiobutton.remove();
    });
    
//    test('Do Change', () {
//      logMessage('Expect dispatch change event when user click on radiobutton');
//      
//      radiobutton.onChange.listen((event) {
//        logMessage('Handle Change Event');
//        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
//        expect(event.type, equals('change'), reason:'must be action event type');
//      });
//      
//      logMessage('Click on radiobutton');
//      radiobutton.callLater((){
//        radiobutton.input.dispatchEvent(new MouseEvent('click'));
//      });
//    });
    
    test('Do Visible', () {
      logMessage('Expect make radiobutton visible or invisible');
      
      radiobutton.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(radiobutton.style.display, equals(''), reason:'must be visible');
        } else {
          expect(radiobutton.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set radiobutton invisible');
      Component.setVisible(radiobutton, false);
      logMessage('Set radiobutton visible');
      Component.setVisible(radiobutton, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude radiobutton from layout');
      
      radiobutton.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(radiobutton.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(radiobutton.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude radiobutton from layout');
      Component.setIncludeInLayout(radiobutton, false);
      logMessage('Include radiobutton in layout');
      Component.setIncludeInLayout(radiobutton, true);
    });
  });
}