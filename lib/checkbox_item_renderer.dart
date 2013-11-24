// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_checkbox_item_renderer;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'list_item_renderer.dart';
import 'item_renderer_owner.dart';
import 'component.dart';

/**
 * The CheckboxItemRenderer class defines the default item renderer for a CheckboxGroup 
 * control. By default, the item renderer draws the checkbox and text associated with each 
 * item in the list.
 * 
 * You can override the default item renderer by creating a custom item renderer.
 */
@CustomTag('m-checkbox-item-renderer')
class CheckboxItemRenderer extends SpanElement with Polymer, Observable, Component implements ListItemRenderer {
  
  /*************
   * Constants *
   *************/
  
  /**
   * Provider of 'change' events.
   */
  static const EventStreamProvider<Event> _changeEvent = const EventStreamProvider<Event>(Component.CHANGE_EVENT);
  
  /**************
   * Properties *
   **************/
  
  /**
   * The data to render or edit.
   */
  @published
  dynamic data;
  dataChanged(old) {
    print('data changed $old to $data');
    updateUI();
  }
  
  /**
   * The String to display in the item renderer. 
   * The host component of the item renderer can use the [itemToLabel] method 
   * to convert the data item to a String for display by the item renderer.
   */
  @published
  String label;
  
  /**
   * The owner of this ItemRenderer object. 
   * By default, it is the parent of this ItemRenderer object.
   * However, if this ItemRenderer object is a child component that is
   * popped up by its parent, such as the drop-down list of a ComboBox control,
   * the owner is the component that popped up this ItemRenderer object.
   */
  ItemRendererOwner owner;
  
  /**
   * Index of rendering data item.
   */
  @published
  int itemIndex;
  
  /**
   * Will equals true if rendering item is first. 
   */
  @published
  bool itemFirst;
  
  /**
   * Will equals true if rendering item is last.
   */
  @published
  bool itemLast;
  
  /**
   * Will equals true if item is odd. 
   */
  @published
  bool itemOdd;
  
  /**
   * Will equals true if rendering item is selected.
   */
  @published
  bool itemSelected = false;
  itemSelectedChanged(old) {
    print('itemSelected is $itemSelected');
    dispatchEvent(new CustomEvent(Component.CHANGE_EVENT, detail:itemSelected));
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
  factory CheckboxItemRenderer() {
    return new Element.tag('span', 'm-checkbox-item-renderer');
  }
  
  /**
   * Constructor instantiated by the DOM when a CheckboxItemRenderer element has 
   * been created.
   */
  CheckboxItemRenderer.created() : super.created();
  
  void updateUI() {
    if (owner != null && data != null) {
      label = owner.itemToLabel(data);
      print('Label is $label');
    }
  }
}