// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void labelTests() {
  logMessage('Performing label tests.');

  group('Testing label:', () {
    Label label;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      label = new Label();
      document.body.append(label);
    });
    
    tearDown((){
      label.remove();
    });
    
    test('Do Visible', () {
      logMessage('Expect make label visible or invisible');
      
      label.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(label.style.display, equals(''), reason:'must be visible');
        } else {
          expect(label.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set label invisible');
      Component.setVisible(label, false);
      logMessage('Set label visible');
      Component.setVisible(label, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude label from layout');
      
      label.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(label.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(label.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude label from layout');
      Component.setIncludeInLayout(label, false);
      logMessage('Include label in layout');
      Component.setIncludeInLayout(label, true);
    });
    
    test('Do Listen Data Change event', () {
      logMessage('Expect listen DataChangeEvent');
      
      label.onDataChange.listen((event){
        logMessage('Handle DataChange Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        var detailData = (event as CustomEvent).detail;
        expect(detailData, equals(dataToSend), reason:'must be the same as ataToSend content');
      });
      
      logMessage('Update data');
      label.data = dataToSend;
    });
  });
}