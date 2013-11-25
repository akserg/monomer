// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void checkboxTests() {
  logMessage('Performing checkbox tests.');

  group('Testing checkbox:', () {
    Checkbox checkbox;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      checkbox = new Checkbox();
      document.body.append(checkbox);
    });
    
    tearDown((){
      checkbox.remove();
    });
    
//    test('Do Change', () {
//      logMessage('Expect dispatch change event when user click on checkbox');
//      
//      checkbox.onChange.listen((event) {
//        logMessage('Handle Change Event');
//        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
//        expect(event.type, equals('change'), reason:'must be action event type');
//      });
//      
//      logMessage('Click on checkbox');
//      checkbox.callLater((){
//        checkbox.input.dispatchEvent(new MouseEvent('click'));
//      });
//    });
    
    test('Do Visible', () {
      logMessage('Expect make checkbox visible or invisible');
      
      checkbox.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(checkbox.style.display, equals(''), reason:'must be visible');
        } else {
          expect(checkbox.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set checkbox invisible');
      Component.setVisible(checkbox, false);
      logMessage('Set checkbox visible');
      Component.setVisible(checkbox, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude checkbox from layout');
      
      checkbox.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(checkbox.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(checkbox.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude checkbox from layout');
      Component.setIncludeInLayout(checkbox, false);
      logMessage('Include checkbox in layout');
      Component.setIncludeInLayout(checkbox, true);
    });
  });
}