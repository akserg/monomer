// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void radioButtonGroupTests() {
  logMessage('Performing radioButtonGroup tests.');

  group('Testing radioButtonGroup:', () {
    RadioButtonGroup radioButtonGroup;
    List items = toObservable([]);
    for (int i = 0; i < 5; i++) {
      items.add({'value':i, 'label':"Order N$i"});
    }
    
    setUp((){
      radioButtonGroup = new RadioButtonGroup();
      document.body.append(radioButtonGroup);
    });
    
    tearDown((){
      radioButtonGroup.remove();
    });
    
    test('Do Visible', () {
      logMessage('Expect make radioButtonGroup visible or invisible');
      
      radioButtonGroup.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(radioButtonGroup.style.display, equals(''), reason:'must be visible');
        } else {
          expect(radioButtonGroup.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set radioButtonGroup invisible');
      Component.setVisible(radioButtonGroup, false);
      logMessage('Set radioButtonGroup visible');
      Component.setVisible(radioButtonGroup, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude radioButtonGroup from layout');
      
      radioButtonGroup.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(radioButtonGroup.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(radioButtonGroup.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude radioButtonGroup from layout');
      Component.setIncludeInLayout(radioButtonGroup, false);
      logMessage('Include radioButtonGroup in layout');
      Component.setIncludeInLayout(radioButtonGroup, true);
    });
    
//    test('Do use ItemRenderer', () {
//      logMessage('Expect works with ItemRenderer');
//      
//      logMessage('Update dataProvider');
//      radioButtonGroup.dataProvider = items;
//      // The duration of 1000ms is enought to take time to redraw our items. 
//      new Timer(new Duration(milliseconds:1000), expectAsync0((){
//        expect(radioButtonGroup.listItems.length, 5, reason:'must be equals 5');
//      }));
//    });
    
    test('Do check itemIndex', () {
      logMessage('Expect correct itemIndex of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.itemIndex(items[2]), equals(2), reason:'must be equals 2');
    });

    test('Do check isItemFirst', () {
      logMessage('Expect correct isItemFirst of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.isItemFirst(items[2]), false, reason:'must be equals false');
      expect(radioButtonGroup.isItemFirst(items[0]), true, reason:'must be equals true');
    });
 
    test('Do check isItemLast', () {
      logMessage('Expect correct isItemLast of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.isItemLast(items[2]), false, reason:'must be equals false');
      expect(radioButtonGroup.isItemLast(items[4]), true, reason:'must be equals true');
    });
 
    test('Do check isItemOdd', () {
      logMessage('Expect correct isItemOdd of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.isItemOdd(items[0]), false, reason:'must be equals false');
      expect(radioButtonGroup.isItemOdd(items[1]), true, reason:'must be equals true');
      expect(radioButtonGroup.isItemOdd(items[2]), false, reason:'must be equals false');
      expect(radioButtonGroup.isItemOdd(items[3]), true, reason:'must be equals true');
      expect(radioButtonGroup.isItemOdd(items[4]), false, reason:'must be equals false');
    });
 
    test('Do check itemToLabel', () {
      logMessage('Expect correct itemToLabel of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.itemToLabel(items[2]), equals("Order N2"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToLabel with labelFunction', () {
      logMessage('Expect correct itemToLabel of data with labelFunction');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      radioButtonGroup.labelFunction = (data) => 'New ${Utility.getValue(data, 'label')}';
      expect(radioButtonGroup.itemToLabel(items[2]), equals("New Order N2"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToValue', () {
      logMessage('Expect correct itemToValue of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.itemToValue(items[2]), equals("2"), reason:'must be equals 2');
    });

    test('Do check isSelected', () {
      logMessage('Expect correct isSelected of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.isSelected(items[2]), equals(false), reason:'must be equals false');
      radioButtonGroup.selectedItems.add(items[2]);
      expect(radioButtonGroup.isSelected(items[2]), equals(true), reason:'must be equals true');
    });

    test('Do check selectAll', () {
      logMessage('Expect correct selectAll of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.selectedItems.length, equals(0), reason:'must be equals 0');
      radioButtonGroup.selectAll(true);
      expect(radioButtonGroup.selectedItems.length, equals(5), reason:'must be equals 5');
      radioButtonGroup.selectAll(false);
      expect(radioButtonGroup.selectedItems.length, equals(0), reason:'must be equals 0');
    });
 
    test('Do check toggleSelection', () {
      logMessage('Expect correct toggleSelection of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.selectedItems.length, equals(0), reason:'must be equals 0');
      radioButtonGroup.toggleSelection(items[2]);
      expect(radioButtonGroup.selectedItems.length, equals(1), reason:'must be equals 1');
      radioButtonGroup.toggleSelection(items[2]);
      expect(radioButtonGroup.selectedItems.length, equals(1), reason:'must be equals 1');
    });

    test('Do check value', () {
      logMessage('Expect correct value of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.value, isNull, reason:'must be equals null');
      
      radioButtonGroup.selectedItems.add(items[2]);
      expect(radioButtonGroup.value, equals(2), reason:'must be number 2');
      
      radioButtonGroup.selectedItems.add(items[3]);
      expect(radioButtonGroup.value, equals(2), reason:'must be number 2');
    });

//    test('Do set value', () {
//      logMessage('Expect correct value of data when set');
//      
//      logMessage('Update dataProvider');
//      radioButtonGroup.dataProvider = items;
//      expect(radioButtonGroup.value, isNull, reason:'must be equals null');
//      
//      radioButtonGroup.value = [items[2],items[3]];
//      expect(radioButtonGroup.selectedItems.length, equals(2), reason:'must be equals 2');
//      expect(radioButtonGroup.selectedItems[0], equals(items[2]), reason:'must be equals item 2');
//      expect(radioButtonGroup.selectedItems[1], equals(items[3]), reason:'must be equals item 3');
//    });
    
    test('Do check selectedIndex', () {
      logMessage('Expect correct selectedIndex of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      radioButtonGroup.selectedItems.add(items[2]);
      expect(radioButtonGroup.selectedIndex, equals(2), reason:'must be equals 2');
      
      radioButtonGroup.selectedItems.add(items[3]);
      expect(radioButtonGroup.selectedIndex, equals(2), reason:'must be equals 2');
    });

    test('Do set selectedIndex', () {
      logMessage('Expect correct set selectedIndex of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      radioButtonGroup.selectedIndex = 2;
      expect(radioButtonGroup.selectedItems.length, equals(1), reason:'must be equals 1');
      expect(radioButtonGroup.selectedItems[0], equals(items[2]), reason:'must be item 2');
      expect(radioButtonGroup.selectedItem, equals(items[2]), reason:'must be item 2');
    });

    test('Do check selectedItem', () {
      logMessage('Expect correct selectedItem of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.selectedItem, isNull, reason:'must be null');
      
      radioButtonGroup.selectedItems.add(items[2]);
      expect(radioButtonGroup.selectedItem, equals(items[2]), reason:'must be equals item 2');
      
      radioButtonGroup.selectedItems.add(items[3]);
      expect(radioButtonGroup.selectedItem, equals(items[2]), reason:'must be equals item 2');
    });
 
    test('Do set selectedItem', () {
      logMessage('Expect correct set selectedItem of data');
      
      logMessage('Update dataProvider');
      radioButtonGroup.dataProvider = items;
      expect(radioButtonGroup.selectedItems.length, equals(0), reason:'must be equals 0');
      
      radioButtonGroup.selectedItem = items[2];
      expect(radioButtonGroup.selectedItems.length, equals(1), reason:'must be equals 1');
      expect(radioButtonGroup.selectedItems[0], equals(items[2]), reason:'must be item 2');
      expect(radioButtonGroup.selectedIndex, equals(2), reason:'must be 2');
    });
  });
}