// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void checkBoxGroupTests() {
  logMessage('Performing checkBoxGroup tests.');

  group('Testing checkBoxGroup:', () {
    CheckBoxGroup checkBoxGroup;
    List items = toObservable([]);
    for (int i = 0; i < 5; i++) {
      items.add({'value':i, 'label':"Order N$i"});
    }
    
    setUp((){
      checkBoxGroup = new CheckBoxGroup();
      document.body.append(checkBoxGroup);
    });
    
    tearDown((){
      checkBoxGroup.remove();
    });
    
    test('Do Visible', () {
      logMessage('Expect make checkBoxGroup visible or invisible');
      
      checkBoxGroup.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(checkBoxGroup.style.display, equals(''), reason:'must be visible');
        } else {
          expect(checkBoxGroup.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set checkBoxGroup invisible');
      Component.setVisible(checkBoxGroup, false);
      logMessage('Set checkBoxGroup visible');
      Component.setVisible(checkBoxGroup, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude checkBoxGroup from layout');
      
      checkBoxGroup.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(checkBoxGroup.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(checkBoxGroup.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude checkBoxGroup from layout');
      Component.setIncludeInLayout(checkBoxGroup, false);
      logMessage('Include checkBoxGroup in layout');
      Component.setIncludeInLayout(checkBoxGroup, true);
    });
    
//    test('Do use ItemRenderer', () {
//      logMessage('Expect works with ItemRenderer');
//      
//      logMessage('Update dataProvider');
//      checkBoxGroup.dataProvider = items;
//      // The duration of 1000ms is enought to take time to redraw our items. 
//      new Timer(new Duration(milliseconds:1000), expectAsync0((){
//        expect(checkBoxGroup.listItems.length, 5, reason:'must be equals 5');
//      }));
//    });
    
    test('Do check itemIndex', () {
      logMessage('Expect correct itemIndex of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.itemIndex(items[2]), equals(2), reason:'must be equals 2');
    });

    test('Do check isItemFirst', () {
      logMessage('Expect correct isItemFirst of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.isItemFirst(items[2]), false, reason:'must be equals false');
      expect(checkBoxGroup.isItemFirst(items[0]), true, reason:'must be equals true');
    });
 
    test('Do check isItemLast', () {
      logMessage('Expect correct isItemLast of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.isItemLast(items[2]), false, reason:'must be equals false');
      expect(checkBoxGroup.isItemLast(items[4]), true, reason:'must be equals true');
    });
 
    test('Do check isItemOdd', () {
      logMessage('Expect correct isItemOdd of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.isItemOdd(items[0]), false, reason:'must be equals false');
      expect(checkBoxGroup.isItemOdd(items[1]), true, reason:'must be equals true');
      expect(checkBoxGroup.isItemOdd(items[2]), false, reason:'must be equals false');
      expect(checkBoxGroup.isItemOdd(items[3]), true, reason:'must be equals true');
      expect(checkBoxGroup.isItemOdd(items[4]), false, reason:'must be equals false');
    });
 
    test('Do check itemToLabel', () {
      logMessage('Expect correct itemToLabel of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.itemToLabel(items[2]), equals("Order N2"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToLabel with labelFunction', () {
      logMessage('Expect correct itemToLabel of data with labelFunction');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      checkBoxGroup.labelFunction = (data) => 'New ${Utility.getValue(data, 'label')}';
      expect(checkBoxGroup.itemToLabel(items[2]), equals("New Order N2"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToValue', () {
      logMessage('Expect correct itemToValue of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.itemToValue(items[2]), equals("2"), reason:'must be equals 2');
    });

    test('Do check isSelected', () {
      logMessage('Expect correct isSelected of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.isSelected(items[2]), equals(false), reason:'must be equals false');
      checkBoxGroup.selectedItems.add(items[2]);
      expect(checkBoxGroup.isSelected(items[2]), equals(true), reason:'must be equals true');
    });

    test('Do check selectAll', () {
      logMessage('Expect correct selectAll of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.selectedItems.length, equals(0), reason:'must be equals 0');
      checkBoxGroup.selectAll(true);
      expect(checkBoxGroup.selectedItems.length, equals(5), reason:'must be equals 5');
      checkBoxGroup.selectAll(false);
      expect(checkBoxGroup.selectedItems.length, equals(0), reason:'must be equals 0');
    });
 
    test('Do check toggleSelection', () {
      logMessage('Expect correct toggleSelection of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.selectedItems.length, equals(0), reason:'must be equals 0');
      checkBoxGroup.toggleSelection(items[2]);
      expect(checkBoxGroup.selectedItems.length, equals(1), reason:'must be equals 1');
      checkBoxGroup.toggleSelection(items[2]);
      expect(checkBoxGroup.selectedItems.length, equals(0), reason:'must be equals 0');
    });

    test('Do check value', () {
      logMessage('Expect correct value of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.value, isNull, reason:'must be equals null');
      
      checkBoxGroup.selectedItems.add(items[2]);
      expect(checkBoxGroup.value, equals('2'), reason:'must be string 2');
      
      checkBoxGroup.selectedItems.add(items[3]);
      expect(checkBoxGroup.value, equals('2,3'), reason:'must be string 2,3');
    });

//    test('Do set value', () {
//      logMessage('Expect correct value of data when set');
//      
//      logMessage('Update dataProvider');
//      checkBoxGroup.dataProvider = items;
//      expect(checkBoxGroup.value, isNull, reason:'must be equals null');
//      
//      checkBoxGroup.value = [items[2],items[3]];
//      expect(checkBoxGroup.selectedItems.length, equals(2), reason:'must be equals 2');
//      expect(checkBoxGroup.selectedItems[0], equals(items[2]), reason:'must be equals item 2');
//      expect(checkBoxGroup.selectedItems[1], equals(items[3]), reason:'must be equals item 3');
//    });
    
    test('Do check selectedIndex', () {
      logMessage('Expect correct selectedIndex of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      checkBoxGroup.selectedItems.add(items[2]);
      expect(checkBoxGroup.selectedIndex, equals(2), reason:'must be equals 2');
      
      checkBoxGroup.selectedItems.add(items[3]);
      expect(checkBoxGroup.selectedIndex, equals(2), reason:'must be equals 2');
    });

    test('Do set selectedIndex', () {
      logMessage('Expect correct set selectedIndex of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      checkBoxGroup.selectedIndex = 2;
      expect(checkBoxGroup.selectedItems.length, equals(1), reason:'must be equals 1');
      expect(checkBoxGroup.selectedItems[0], equals(items[2]), reason:'must be item 2');
      expect(checkBoxGroup.selectedItem, equals(items[2]), reason:'must be item 2');
    });

    test('Do check selectedItem', () {
      logMessage('Expect correct selectedItem of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.selectedItem, isNull, reason:'must be null');
      
      checkBoxGroup.selectedItems.add(items[2]);
      expect(checkBoxGroup.selectedItem, equals(items[2]), reason:'must be equals item 2');
      
      checkBoxGroup.selectedItems.add(items[3]);
      expect(checkBoxGroup.selectedItem, equals(items[2]), reason:'must be equals item 2');
    });
 
    test('Do set selectedItem', () {
      logMessage('Expect correct set selectedItem of data');
      
      logMessage('Update dataProvider');
      checkBoxGroup.dataProvider = items;
      expect(checkBoxGroup.selectedItems.length, equals(0), reason:'must be equals 0');
      
      checkBoxGroup.selectedItem = items[2];
      expect(checkBoxGroup.selectedItems.length, equals(1), reason:'must be equals 1');
      expect(checkBoxGroup.selectedItems[0], equals(items[2]), reason:'must be item 2');
      expect(checkBoxGroup.selectedIndex, equals(2), reason:'must be 2');
    });
  });
}