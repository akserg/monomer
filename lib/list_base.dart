// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_list_base;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'list_item_renderer.dart';
import 'component.dart';
import 'utility.dart';

/**
 *  The ListBase class is the base class for controls that represent lists
 *  of items that can have one or more selected and can scroll through the
 *  items.  Items are supplied using the <code>dataProvider</code> property
 *  and displayed via item renderers.
 */
abstract class ListBase {

  /***********
   * CONSTANTS
   **********/
  
  static const String CHANGE_EVENT = "change";
  
  /**************
   * Properties *
   **************/
  
  /**
   * Data Provider instance
   */
  ObservableList get dataProvider;
  
  bool get allowSelectFirst;
  bool get allowMultipleSelection;
  bool get autoScrollToSelection;
  String get labelPath;
  String get valuePath;

  dynamic _value;
  String valueSeparator;
  
  /**
   * Return a reference to the selected item in the data provider.
   */
  dynamic get selectedItem {
    print('get selectedItem');
    if (selectedItems.length > 0)
      return this.selectedItems[0];
    return null;
  }
  
  /**
   * Set a reference to the selected [item] in the data provider.
   */
  void set selectedItem(dynamic item) {
    print('set selectedItem');
    selectedItems.clear();
    if (item != null) {
      selectedItems.add(item);
    }
    updateUI();
  }
  
  /**
   * Return an array of references to the selected items in the data provider.
   */
  ObservableList get selectedItems;
  
  /**
   * Return the index in the data provider of the selected item.
   */
  int get selectedIndex {
    return selectedItem == null ? -1 : dataProvider.indexOf(selectedItem);
  }
  
  /**
   * Set the index in the data provider of the selected item.
   */
  void set selectedIndex(int value) {
    if (value >= 0 && value < dataProvider.length) {
      selectedItem = dataProvider[value];
      updateUI();
    } else if (value == -1) {
      selectedItem = null;
    } else {
      throw new Exception("Out of bound exception");
    }
  }
  
  /**
   * Return list or string of values of [selectedItems]. If [valueSeparator] 
   * specified value from [selectedItems] will transformed to string. Transformation 
   * uses property [valuePath], if specified.
   */
  dynamic get value {
    if (allowMultipleSelection) {
      List items = selectedItems;
      if (items.length == 0) {
        return _value;
      }
      items = Utility.getValues(items, valuePath);
      if (valueSeparator == null) {
        return items;
      } else {
        return items.join(valueSeparator);
      }
    } else {
      dynamic s = selectedItem;
      if (s == null) {
        return _value;
      }
      if (valuePath != null) {
        s = s[valuePath];
      }
      return s;
    }
  }
  
  /**
   * Set value as list or string of values of real data of dataProvider.
   */
  void set value(dynamic v) {
    _value = v;
    selectedItems.clear();
    if (v != null) {
      var dataItems = dataProvider;
      List result;
      if (allowMultipleSelection && valueSeparator != null) {
        if (v is String) {
          result = v.split(valueSeparator);
        } else {
          result = v; // as List
        }
      } else if (v is List) {
        result = v;
      } else {
        result = [v];
      }
      selectedItems.addAll(Utility.intersect(dataItems, valuePath, result));
      updateUI();
    }
  }
  
  /***********
   * Methods *
   ***********/

  /**
   * Initialise ListBase mixin with [owner] info.
   */
  void initializeListBase(owner) {
    onPropertyChange(owner, #dataProvider, (){
      print('onPropertyChange dataProvider: $dataProvider');
      selectAll(false);
    });
    onPropertyChange(owner, #selectedItems, (){
      print('onPropertyChange selectedItems: $selectedItems');
      owner.dispatchEvent(new CustomEvent(CHANGE_EVENT, detail:value));
    });
    selectedItems.changes.listen((v) {
      print('selectedItems changed: $selectedItems');
      owner.dispatchEvent(new CustomEvent(CHANGE_EVENT, detail:value));
    });
  }

  /**
   * Return list of instanses of item renderer components.
   */
  List<Element> get itemRenderers;

  /**
   * Convinience method to update state of each item renderer. 
   */
  void updateUI() {
    for (int i = 0; i < itemRenderers.length; i++) {
      updateItem(itemRenderers[i]);
    }
  }
  
  /**
   * Update state of [item].
   */
  void updateItem(Element item) {
    if (item is ListItemRenderer && item is Component) {
      (item as ListItemRenderer).itemSelected = isSelected((item as Component).data);
    }
  }

   /**
   * Helper function return index of item [data].
   */
  int itemIndex(data) {
    return dataProvider.indexOf(data);
  }
  
  /**
   * Helper function check is item [data] is first.
   */
  bool isItemFirst(data) {
    return itemIndex(data) == 0;
  }

  /**
   * Helper function check is item [data] is .
   */
  bool isItemLast(data) {
    return itemIndex(data) == dataProvider.length - 1;
  }

  /**
   * Helper function check is item [data] is odd.
   */
  bool isItemOdd(data) {
    return itemIndex(data) % 2 == 1;
  }
  
  /**
   * Transform [data] to label with [labelPath].
   */
  String itemToLabel(data) {
    print('itemToLabel for $data');
    return labelPath == null ? data : data == null ? null : data[labelPath];
  }
  
  /**
   * Transform [data] to label with [valuePath].
   */
  String itemToValue(data) {
    print('itemToValue for $data');
    return valuePath == null ? data : data == null ? null : data[valuePath];
  }
 
  /****************************
   * Selection Business logic *
   ****************************/
  
  /**
   * Check if [item] selected.
   */
  bool isSelected(dynamic item) {
    assert(item != null);
    return selectedItems.indexOf(item) != -1;
  }
  
  /**
   * Add or remove selection to all depends on [value].
   */
  void selectAll(bool value) {
    selectedItems.clear();
    if (value && dataProvider != null) {
      selectedItems.addAll(dataProvider);
    }
    updateUI();
  }
  
  
  /**
   * Scrolls first selected element into view.
   */
  void scrollSelectedIntoView() {
    // do not scroll for first auto select 
    if (allowSelectFirst && selectedIndex == 0)
      return;
    // Move through item renderers and select first selected
    for (Iterator ae = itemRenderers.iterator; ae.moveNext();) {
      Element item = ae.current;
      if (item is ListItemRenderer) {
        if ((item as ListItemRenderer).itemSelected) {
          item.scrollIntoView();
          return;
        }
      }
    }
  }
  
  /**
   * Toggle selection of [data] item.
   */
  void toggleSelection(dynamic data) {
    print('allowMultipleSelection is $allowMultipleSelection');
    if (allowMultipleSelection) {
      if (selectedItems.contains(data)) {
        selectedItems.remove(data);
      } else {
        selectedItems.add(data);
      }
    } else if (!selectedItems.contains(data)) {
      selectedItems.clear();
      selectedItems.add(data);
    }
    updateUI();
  }
}