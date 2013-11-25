// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void listBaseTests() {
  logMessage('Performing listBase tests.');

  group('Testing listBase:', () {
    ListBase listBase;
    List items = toObservable([]);
    for (int i = 0; i < 5; i++) {
      items.add({'value':i, 'label':"Order N$i"});
    }
    
    setUp((){
      listBase = new ListBase();
      document.body.append(listBase);
    });
    
    tearDown((){
      listBase.remove();
    });
    
    test('Do Visible', () {
      logMessage('Expect make listBase visible or invisible');
      
      listBase.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(listBase.style.display, equals(''), reason:'must be visible');
        } else {
          expect(listBase.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set listBase invisible');
      Component.setVisible(listBase, false);
      logMessage('Set listBase visible');
      Component.setVisible(listBase, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude listBase from layout');
      
      listBase.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(listBase.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(listBase.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude listBase from layout');
      Component.setIncludeInLayout(listBase, false);
      logMessage('Include listBase in layout');
      Component.setIncludeInLayout(listBase, true);
    });
    
    test('Do use ItemRenderer', () {
      logMessage('Expect works with ItemRenderer');
      
      listBase.itemRenderer = 'span.m-label';
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      // The duration of 1000ms is enought to take time to redraw our items. 
      new Timer(new Duration(milliseconds:1000), expectAsync0((){
        expect(listBase.listItems.length, 5, reason:'must be equals 5');
      }));
    });
    
    test('Do check itemIndex', () {
      logMessage('Expect correct itemIndex of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.itemIndex(items[2]), equals(2), reason:'must be equals 2');
    });

    test('Do check isItemFirst', () {
      logMessage('Expect correct isItemFirst of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.isItemFirst(items[2]), false, reason:'must be equals false');
      expect(listBase.isItemFirst(items[0]), true, reason:'must be equals true');
    });
 
    test('Do check isItemLast', () {
      logMessage('Expect correct isItemLast of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.isItemLast(items[2]), false, reason:'must be equals false');
      expect(listBase.isItemLast(items[4]), true, reason:'must be equals true');
    });
 
    test('Do check isItemOdd', () {
      logMessage('Expect correct isItemOdd of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.isItemOdd(items[0]), false, reason:'must be equals false');
      expect(listBase.isItemOdd(items[1]), true, reason:'must be equals true');
      expect(listBase.isItemOdd(items[2]), false, reason:'must be equals false');
      expect(listBase.isItemOdd(items[3]), true, reason:'must be equals true');
      expect(listBase.isItemOdd(items[4]), false, reason:'must be equals false');
    });
 
    test('Do check itemToLabel', () {
      logMessage('Expect correct itemToLabel of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.itemToLabel(items[2]), equals("{value: 2, label: Order N2}"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToLabel with labelPath', () {
      logMessage('Expect correct itemToLabel of data with labelPath');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.labelPath = 'label';
      expect(listBase.itemToLabel(items[2]), equals("Order N2"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToLabel with labelFunction', () {
      logMessage('Expect correct itemToLabel of data with labelFunction');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.labelFunction = (data) => 'New ${Utility.getValue(data, 'label')}';
      expect(listBase.itemToLabel(items[2]), equals("New Order N2"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToValue', () {
      logMessage('Expect correct itemToValue of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.itemToValue(items[2]), equals("{value: 2, label: Order N2}"), reason:'must be equals Order N2');
    });
    
    test('Do check itemToValue with valuePath', () {
      logMessage('Expect correct itemToValue of data with valuePath');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.valuePath = 'value';
      expect(listBase.itemToValue(items[2]), equals("2"), reason:'must be equals 2');
    });

    test('Do check isSelected', () {
      logMessage('Expect correct isSelected of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.isSelected(items[2]), equals(false), reason:'must be equals false');
      listBase.selectedItems.add(items[2]);
      expect(listBase.isSelected(items[2]), equals(true), reason:'must be equals true');
    });

    test('Do check selectAll', () {
      logMessage('Expect correct selectAll of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.selectedItems.length, equals(0), reason:'must be equals 0');
      listBase.selectAll(true);
      expect(listBase.selectedItems.length, equals(5), reason:'must be equals 5');
      listBase.selectAll(false);
      expect(listBase.selectedItems.length, equals(0), reason:'must be equals 0');
    });
 
    test('Do check toggleSelection', () {
      logMessage('Expect correct toggleSelection of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.selectedItems.length, equals(0), reason:'must be equals 0');
      listBase.toggleSelection(items[2]);
      expect(listBase.selectedItems.length, equals(1), reason:'must be equals 1');
      listBase.toggleSelection(items[2]);
      expect(listBase.selectedItems.length, equals(1), reason:'must be equals 1');
    });
    
    test('Do check toggleSelection with allowMultipleSelection', () {
      logMessage('Expect correct toggleSelection of data with allowMultipleSelection');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.allowMultipleSelection = true;
      expect(listBase.selectedItems.length, equals(0), reason:'must be equals 0');
      listBase.toggleSelection(items[2]);
      expect(listBase.selectedItems.length, equals(1), reason:'must be equals 1');
      listBase.toggleSelection(items[2]);
      expect(listBase.selectedItems.length, equals(0), reason:'must be equals 0');
    });

    test('Do check value', () {
      logMessage('Expect correct value of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.value, isNull, reason:'must be equals null');
      
      listBase.selectedItems.add(items[2]);
      expect(listBase.value, equals(items[2]), reason:'must be equals instance 2');
      
      listBase.selectedItems.add(items[3]);
      expect(listBase.value, equals(items[2]), reason:'must be equals instance 2');
      
      listBase.valuePath = 'value';
      expect(listBase.value, equals(2), reason:'must be equals 2');
    });
    
    test('Do check value with allowMultipleSelection', () {
      logMessage('Expect correct value of data with allowMultipleSelection');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.allowMultipleSelection = true;
      expect(listBase.value, isNull, reason:'must be equals null');
      
      listBase.selectedItems.add(items[2]);
      expect(listBase.value, equals([items[2]]), reason:'must be list with item 2');
      
      listBase.selectedItems.add(items[3]);
      expect(listBase.value, equals([items[2],items[3]]), reason:'must be list with items 2 and 3');
      
      listBase.valuePath = 'value';
      expect(listBase.value, equals([2, 3]), reason:'must be list with numbers 2 and 3');
      
      listBase.valueSeparator = ',';
      expect(listBase.value, equals('2,3'), reason:'must be equals 2,3');
    });

    test('Do set value', () {
      logMessage('Expect correct value of data when set');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.value, isNull, reason:'must be equals null');
      
      listBase.value = [items[2],items[3]];
      expect(listBase.selectedItems.length, equals(2), reason:'must be equals 2');
      expect(listBase.selectedItems[0], equals(items[2]), reason:'must be equals item 2');
      expect(listBase.selectedItems[1], equals(items[3]), reason:'must be equals item 3');
    });
    
//    test('Do set value with valueSepetor and valuePath', () {
//      logMessage('Expect correct value of data when set');
//      
//      logMessage('Update dataProvider');
//      listBase.dataProvider = items;
//      listBase.valuePath = 'value';
//      listBase.valueSeparator = ',';
//      listBase.allowMultipleSelection = true;
//      expect(listBase.value, isNull, reason:'must be equals null');
//      
//      listBase.value = "2";
//      expect(listBase.selectedItems.length, equals(1), reason:'must be equals 1');
//      expect(listBase.selectedItems[0], equals(items[2]), reason:'must be equals item 2');
//    });
 
    test('Do check selectedIndex', () {
      logMessage('Expect correct selectedIndex of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.selectedItems.add(items[2]);
      expect(listBase.selectedIndex, equals(2), reason:'must be equals 2');
      
      listBase.selectedItems.add(items[3]);
      expect(listBase.selectedIndex, equals(2), reason:'must be equals 2');
    });

    test('Do set selectedIndex', () {
      logMessage('Expect correct set selectedIndex of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      listBase.selectedIndex = 2;
      expect(listBase.selectedItems.length, equals(1), reason:'must be equals 1');
      expect(listBase.selectedItems[0], equals(items[2]), reason:'must be item 2');
      expect(listBase.selectedItem, equals(items[2]), reason:'must be item 2');
    });

    test('Do check selectedItem', () {
      logMessage('Expect correct selectedItem of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.selectedItem, isNull, reason:'must be null');
      
      listBase.selectedItems.add(items[2]);
      expect(listBase.selectedItem, equals(items[2]), reason:'must be equals item 2');
      
      listBase.selectedItems.add(items[3]);
      expect(listBase.selectedItem, equals(items[2]), reason:'must be equals item 2');
    });
 
    test('Do set selectedItem', () {
      logMessage('Expect correct set selectedItem of data');
      
      logMessage('Update dataProvider');
      listBase.dataProvider = items;
      expect(listBase.selectedItems.length, equals(0), reason:'must be equals 0');
      
      listBase.selectedItem = items[2];
      expect(listBase.selectedItems.length, equals(1), reason:'must be equals 1');
      expect(listBase.selectedItems[0], equals(items[2]), reason:'must be item 2');
      expect(listBase.selectedIndex, equals(2), reason:'must be 2');
    });
  });
}
