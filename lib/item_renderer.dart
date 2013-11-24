// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_item_renderer;

import 'dart:html';

import 'item_renderer_owner.dart';
import 'component.dart';

/**
 * The ItemRenderer interface defines the basic set of APIs that a class must 
 * implement to create an item renderer that can communicate with a host component.
 * The host component, such as the List or ButtonBar controls, must implement 
 * the ItemRendererOwner interface. 
 * The ItemRenderer defines the interface for components that have a [data]
 * property.
 */
abstract class ItemRenderer implements Element, Component {
  
  /**
   * The data to render or edit.
   */
  dynamic data;
  
  /**
   * The String to display in the item renderer. 
   * The host component of the item renderer can use the [itemToLabel] method 
   * to convert the data item to a String for display by the item renderer.
   */
  String label;
  
  /**
   * The owner of this ItemRenderer object. 
   * By default, it is the parent of this ItemRenderer object.
   * However, if this ItemRenderer object is a child component that is
   * popped up by its parent, such as the drop-down list of a ComboBox control,
   * the owner is the component that popped up this ItemRenderer object.
   */
  ItemRendererOwner owner;
}