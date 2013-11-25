// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void checkboxGroupTests() {
  logMessage('Performing checkboxGroup tests.');

  group('Testing checkboxGroup:', () {
    CheckboxGroup checkboxGroup;
    List items = toObservable([]);
    for (int i = 0; i < 5; i++) {
      items.add({'value':i, 'label':"Order N$i"});
    }
    
    setUp((){
      checkboxGroup = new CheckboxGroup();
      document.body.append(checkboxGroup);
    });
    
    tearDown((){
      checkboxGroup.remove();
    });
    
    test('Do Visible', () {
      logMessage('Expect make checkboxGroup visible or invisible');
      
      checkboxGroup.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(checkboxGroup.style.display, equals(''), reason:'must be visible');
        } else {
          expect(checkboxGroup.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set checkboxGroup invisible');
      Component.setVisible(checkboxGroup, false);
      logMessage('Set checkboxGroup visible');
      Component.setVisible(checkboxGroup, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude checkboxGroup from layout');
      
      checkboxGroup.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(checkboxGroup.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(checkboxGroup.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude checkboxGroup from layout');
      Component.setIncludeInLayout(checkboxGroup, false);
      logMessage('Include checkboxGroup in layout');
      Component.setIncludeInLayout(checkboxGroup, true);
    });
    
    test('Do use ItemRenderer', () {
      logMessage('Expect works with ItemRenderer');
      
      logMessage('Update dataProvider');
      checkboxGroup.dataProvider = items;
      // The duration of 1000ms is enought to take time to redraw our items. 
      new Timer(new Duration(milliseconds:1000), expectAsync0((){
        expect(checkboxGroup.listItems.length, 5, reason:'must be equals 5');
      }));
    });
  });
}