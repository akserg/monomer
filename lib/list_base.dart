// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_listbase;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import "package:log4dart/log4dart.dart";

import 'component.dart';
import 'item_renderer.dart';
import 'item_renderer_owner.dart';

import 'utility.dart';

/**
 * The ListBase class is the base class for all components that support selection.
 */
@CustomTag('m-list-base')
class ListBase extends DivElement with Polymer, Observable, Component implements ItemRendererOwner {

  static final _logger = LoggerFactory.getLoggerFor(ListBase);
  
  /***********
   * CONSTANTS
   **********/
  
  /**
   * Provider of 'action' events.
   */
  static const EventStreamProvider<Event> _actionEvent = const EventStreamProvider<Event>(Component.ACTION_EVENT);
  
  /**
   * Provider of 'visible' events.
   */
  static const EventStreamProvider<Event> _visibleEvent = const EventStreamProvider<Event>(Component.VISIBLE_EVENT);
  
  /**
   * Provider of 'includeInLayout' events.
   */
  static const EventStreamProvider<Event> _includeInLayoutEvent = const EventStreamProvider<Event>(Component.INCLUDE_IN_LAYOUT_EVENT);
  
  /**
   * Provider of 'success' events.
   */
  static const EventStreamProvider<Event> _successEvent = const EventStreamProvider<Event>(Component.SUCCESS_EVENT);
  
  /**
   * Provider of 'fault' events.
   */
  static const EventStreamProvider<Event> _faultEvent = const EventStreamProvider<Event>(Component.FAULT_EVENT);
  
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
   * Instance of [ItemRenderer] using to rendering content of items.
   */
  @published
  String itemRenderer = "span.m-label";
  itemRendererChanged(old) {
    _logger.debug('itemRendererChanged $itemRenderer');
    callLater(updateUI);
  }
  
  /**
   * Style applying to each item renderer.
   */
  @published
  String itemRendererClass;
  itemRendererClassChanged(old) {
    _logger.debug('itemRendererClassChanged $itemRendererClass');
    callLater(updateUI);
  }
  
  /**
   * Style applying to each selected item renderer.
   */
  @published
  String itemRendererSelectedClass;
  itemRendererSelectedClassChanged(old) {
    _logger.debug('itemRendererSelectedClassChanged $itemRendererSelectedClass');
    callLater(updateUI);
  }
  
  /**
   * Map of NodeBindings.
   */
  Map<ItemRenderer, NodeBindExtension> listItems = {};
  
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
  @published
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
    if (selectedItems.length > 0)
      return this.selectedItems[0];
    return null;
  }
  
  /**
   * Set a reference to the selected [item] in the data provider.
   */
  void set selectedItem(dynamic item) {
    selectedItems.clear();
    if (item != null) {
      selectedItems.add(item);
    }
    notifyPropertyChange(#selectedItems, null, selectedItems);
    callLater(updateListItems);
  }
  
  /**
   * Return the index in the data provider of the selected item.
   */
  int get selectedIndex {
    return selectedItem == null ? -1 : dataProvider.indexOf(selectedItem);
  }
  
  /**
   * Select item by [index].
   */
  void set selectedIndex(int index) {
    if (index >= 0 && index < dataProvider.length) {
      selectedItem = dataProvider[index];
    } else if (index == -1) {
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
      callLater(updateListItems);
    }
    notifyPropertyChange(#selectedItems, null, selectedItems);
  }
  
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'action' events handled by this element.
   */
  ElementStream<Event> get onAction => _actionEvent.forElement(this);
  
  /**
   * Stream of 'visible' events handled by this element.
   */
  ElementStream<Event> get onVisible => _visibleEvent.forElement(this);
  
  /**
   * Stream of 'includeInLayout' events handled by this element.
   */
  ElementStream<Event> get onIncludeInLayout => _includeInLayoutEvent.forElement(this);
  
  /**
   * Stream of 'success' events handled by this element.
   */
  ElementStream<Event> get onSuccess => _successEvent.forElement(this);
  
  /**
   * Stream of 'fault' events handled by this element.
   */
  ElementStream<Event> get onFault => _faultEvent.forElement(this);
  
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
      _logger.debug('onPropertyChange dataProvider: $dataProvider');
      // Remove selection and call updateListItems methods afterwords
      selectAll(false);
      // Redraw UI
      callLater(() {
        updateUI();
        selectFirst();
      });
    });
    onPropertyChange(this, #selectedItems, (){
      _logger.debug('onPropertyChange selectedItems: $selectedItems');
      updateListItems();
      if (autoScrollToSelection) {
        scrollSelectedIntoView();
      }
      dispatchEvent(new CustomEvent(Component.CHANGE_EVENT, detail:value));
    });
  }
  
  /**
   * Call to redraw UI.
   */
  @override
  void enteredView() {
    super.enteredView();
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
    _logger.debug('itemToLabel for $data');
    if (data != null) {
      if (labelFunction != null) {
        return labelFunction(data);
      } else if (labelPath != null) {
        return Utility.getValue(data, labelPath);
      } else {
        return data.toString();
      }
    }
    return '';
  }
  
  /**
   * Transform [data] to label with [valuePath].
   */
  String itemToValue(data) {
    _logger.debug('itemToValue for $data');
    if (data != null) {
      if (valuePath != null) {
        dynamic value = Utility.getValue(data, valuePath);
        return value == null ? '' : value.toString();
      } else {
        return data.toString();
      }
    }
    return '';
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
    callLater(updateListItems);
    notifyPropertyChange(#selectedItems, null, selectedItems);
  }
  
  
  /**
   * Scrolls first selected element into view.
   */
  void scrollSelectedIntoView() {
    // do not scroll for first auto select 
    if (allowSelectFirst && selectedIndex == 0)
      return;
    // Scroll first selected item into view.
    listItems.keys.firstWhere((ItemRenderer renderer){
      if (renderer.itemSelected) {
        renderer.scrollIntoView();
        return true;
      }
      return false;
    });
  }
  
  
  /**
   * Select [data] depends on [value].
   */
  void select(dynamic data, bool value) {
    _logger.debug('select ${data}');
    if (allowMultipleSelection) {
      _logger.debug('allowMultipleSelection is $allowMultipleSelection');
      if (selectedItems.contains(data) && !value) {
        _logger.debug('Remove Selection ${data}');
        selectedItems.remove(data);
        notifyPropertyChange(#selectedItems, null, selectedItems);
      } else if (!selectedItems.contains(data) && value) {
        _logger.debug('Add Selection ${data}');
        selectedItems.add(data);
        notifyPropertyChange(#selectedItems, null, selectedItems);
      }
    } else if (!selectedItems.contains(data) && value) {
      _logger.debug('Add Selection ${data}');
      selectedItems.clear();
      selectedItems.add(data);
      notifyPropertyChange(#selectedItems, null, selectedItems);
    }
  }
  
  /**
   * Select first item if [allowSelectFirst] equals true. 
   */
  void selectFirst() {
    if (allowSelectFirst && dataProvider.length > 0) {
      _logger.debug('selectFirst accepted');
      selectedIndex = 0;
    }
  }
  
  /**********
   * Update *
   *********/
  
  /**
   * Convinience method to update state of each item renderer. 
   */
  void updateListItems() {
    listItems.forEach((ItemRenderer renderer, NodeBindExtension nodeBind){
      updateItemState(renderer);
      updateItemStyle(renderer);
    });
  }
  
  /**
   * Update state of [item].
   */
  void updateItemState(ItemRenderer item) {
    item.itemSelected = isSelected(item.data);
    _logger.debug('updateItemState. ${item.itemSelected} of ${item.data}');
  }
  
  /**
   * Update style of [item].
   */
  void updateItemStyle(ItemRenderer item) {
    if (item.itemSelected && itemRendererSelectedClass != null) {
      item.className = itemRendererSelectedClass;
    } else if (itemRendererClass != null) {
      item.className = itemRendererClass;
    } else {
      item.className = "";
    }
    _logger.debug('updateItemStyle. ${item.className} of ${item.data}');
  }
  
  /**
   * Update display list of UI.
   */
  void updateUI() {
    _logger.debug('updateUI');
    removeUIItems();
    addUIItems();
  }
  
  /**
   * Remove old ItemRenderers.
   */
  void removeUIItems() {
    // Remove old
    listItems.forEach((ItemRenderer item, NodeBindExtension bindExt) {
      _logger.debug('updateUI.remove $item');
      bindExt.unbindAll();
      item.remove();
    });
    listItems.clear();
  }
  
  /**
   * Create new ItemRenderers based on [dataProvider] and [itemRenderer].
   */
  void addUIItems() {
    if (itemRenderer != null) {
      dataProvider.forEach((data){
        _logger.debug('updateUI.render $data');
        // Instantiate [itemRenderer]
        ItemRenderer renderer = instantiateItemRenderer();
        // Bind renderer properties to local one
        NodeBindExtension bindExt = nodeBind(renderer)
            ..bind('data', data, '');
        // Append new renderer to owner
        owner.append(renderer);
        // Keep them until update or remove
        listItems[renderer] = bindExt;
        _logger.debug('updateUI.add $renderer');
      });
    } else {
      _logger.warn('The item renderer was not specified.');
    }
  }
  
  /**
   * Create an instance of [itemRenderer].
   */
  ItemRenderer instantiateItemRenderer() {
    ItemRenderer renderer;
    if (itemRenderer.contains('.')) {
      List<String> parts = itemRenderer.split(".");
      _logger.debug('ItemRenderer are ${parts[0]}, ${parts[1]}');
      renderer = new Element.tag(parts[0], parts[1]);
    } else {
      _logger.debug('ItemRenderer is $itemRenderer');
      renderer = new Element.tag(itemRenderer);
    }
    if (itemRendererClass != null) {
      renderer.className = itemRendererClass;
    }
    renderer.onDataChange.listen((CustomEvent event){
      ItemRenderer item = event.target;
      item.label = itemToLabel(item.data);
    });
    return renderer;
  }
  
  
}