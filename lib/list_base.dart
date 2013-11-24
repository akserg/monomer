// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_listbase;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';

import 'component.dart';
import 'list_item_renderer.dart';
import 'item_renderer_owner.dart';

import 'utility.dart';

/**
 * The ListBase class is the base class for all components that support selection.
 */
@CustomTag('m-list-base')
class ListBase extends DivElement with Polymer, Observable, Component implements ItemRendererOwner {

  /***********
   * CONSTANTS
   **********/
  /**
   * Provider of 'change' events.
   */
  static const EventStreamProvider<Event> _changeEvent = const EventStreamProvider<Event>(Component.CHANGE_EVENT);
  
  /**************
   * PROPERTIES *
   **************/
  
  /**
   * Data Provider instance
   */
  @published
  ObservableList dataProvider = toObservable([]);
  
  /**
   * Return an array of references to the selected items in the data provider.
   */
  @published
  ObservableList selectedItems = toObservable([]);
  
  /**
   * Instance of [ListItemRenderer] using to rendering content of items.
   */
  @published
  String itemRenderer;
  itemRendererChanged(old) {
    callLater(updateUI);
  }
  
  /**
   * Map of NodeBindings.
   */
  Map<ListItemRenderer, NodeBindExtension> itemRenderers = {};
  
  /**
   * Owner of ItemRenderers. By default it's [shadowRoot], but any other
   * point in shadowRoot can be returned as well.
   */
  Node get owner => shadowRoot;
  
  /**
   * Flag allows select first item by default.
   */
  @published
  bool allowSelectFirst = false;
  
  /**
   * Flag allows select multiple items. 
   */
  @published
  bool allowMultipleSelection = false;
  
  /**
   * Flag allows scroll to show selected items.
   */
  @published
  bool autoScrollToSelection = false;
  
  /**
   * Path used to find the label.
   */
  @published
  String labelPath;
  
  /**
   * Path used to find the label.
   */
  @published
  Function labelFunction;
  
  /**
   * Path used to find the value.
   */
  @published
  String valuePath;

  /**
   * Separator used to split data before send to string
   */
  String valueSeparator;

  /**
   * Inteesentation of [Value].
   */
  dynamic _value;
  
  /**
   * Return a reference to the selected item in the data provider.
   */
  @published
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
    callLater(updateSelectedItems);
  }
  
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
      callLater(updateSelectedItems);
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
        s = Utility.getValue(s, valuePath);
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
        result = v.toString().split(valueSeparator);
      } else if (v is List) {
        result = v;
      } else {
        result = [v];
      }
      selectedItems.addAll(Utility.intersect(dataItems, valuePath, result));
      callLater(updateSelectedItems);
    }
  }
  
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'change' events handled by this element.
   */
  ElementStream<Event> get onChange => _changeEvent.forElement(this);
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory ListBase() {
    return new Element.tag('div', 'm-list-base');
  }
  
  /**
   * Constructor instantiated by the DOM when a ListBase element has been 
   * created.
   */
  ListBase.created() : super.created() {
    onPropertyChange(this, #dataProvider, (){
      print('onPropertyChange dataProvider: $dataProvider');
      // Remove selection and call updateSelectedItems methods afterwords
      selectAll(false);
      callLater(updateUI);
    });
    onPropertyChange(this, #selectedItems, (){
      print('onPropertyChange selectedItems: $selectedItems');
      callLater((){
        updateSelectedItems();
        dispatchEvent(new CustomEvent(Component.CHANGE_EVENT, detail:value));
      });
    });
  }
  
  @override
  void enteredView() {
    super.enteredView();
    print('enteredView');
    callLater(updateUI);
  }
  
  /***************
   * Translation *
   ***************/
  
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
    return labelFunction != null ? labelFunction(data) : 
           labelPath == null ? data : data == null ? null : Utility.getValue(data, labelPath);
  }
  
  /**
   * Transform [data] to label with [valuePath].
   */
  String itemToValue(data) {
    print('itemToValue for $data');
    return valuePath == null ? data : data == null ? null : Utility.getValue(data, valuePath);
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
    callLater(updateSelectedItems);
  }
  
  
  /**
   * Scrolls first selected element into view.
   */
  void scrollSelectedIntoView() {
    // do not scroll for first auto select 
    if (allowSelectFirst && selectedIndex == 0)
      return;
    // Move through item renderers and select first selected
    itemRenderers.keys.firstWhere((ListItemRenderer renderer){
      if (renderer.itemSelected) {
        renderer.scrollIntoView();
        return true;
      }
      return false;
    });
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
    notifyPropertyChange(#selectedItems, null, selectedItems);
    callLater(updateSelectedItems);
  }
  
  /**********
   * Update *
   *********/
  
  /**
   * Convinience method to update state of each item renderer. 
   */
  void updateSelectedItems() {
    itemRenderers.forEach((ListItemRenderer renderer, NodeBindExtension nodeBind){
      updateItem(renderer);
    });
  }
  
  /**
   * Update state of [item].
   */
  void updateItem(ListItemRenderer item) {
    item.itemSelected = isSelected(item.data);
  }
  
  /**
   * Update display list of UI.
   */
  void updateUI() {
    print('updateUI');
    removeUIItems();
    addUIItems();
  }
  
  /**
   * Remove old ItemRenderers.
   */
  void removeUIItems() {
    // Remove old
    itemRenderers.forEach((ListItemRenderer item, NodeBindExtension bindExt) {
      print('updateUI.remove $item');
      bindExt.unbindAll();
      item.remove();
    });
    itemRenderers.clear();
  }
  
  /**
   * Create new ItemRenderers based on [dataProvider] and [itemRenderer].
   */
  void addUIItems() {
    if (itemRenderer != null) {
      dataProvider.forEach((data){
        //
        print('updateUI.render $data');
        // Instantiate [itemRenderer]
        ListItemRenderer renderer = instantiateItemRenderer();
        // Bind renderer properties to local
        NodeBindExtension bindExt = nodeBind(renderer)
            ..bind('data', data, '');
        // Append new renderer to owner
        owner.append(renderer);
        // Keep them until update or remove
        itemRenderers[renderer] = bindExt;
        print('updateUI.add $renderer');
      });
    }
  }
  
  /**
   * Create an instance of [itemRenderer].
   */
  ListItemRenderer instantiateItemRenderer() {
    ListItemRenderer renderer;
    if (itemRenderer.contains('.')) {
      List<String> parts = itemRenderer.split(".");
      print('updateUI.itemRenderer are ${parts[0]}, ${parts[1]}');
      renderer = new Element.tag(parts[0], parts[1]);
    } else {
      print('updateUI.itemRenderer is $itemRenderer');
      renderer = new Element.tag(itemRenderer);
    }
    renderer.owner = this;
    return renderer;
  }
}