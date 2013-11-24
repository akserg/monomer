// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_check_box_group;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'list_item_renderer.dart';
import 'list_base.dart';
import 'component.dart';

/**
 *  CheckboxList is inherited from ListBase, but by default it allows multiple 
 *  selection and automatically provides comma separated values as value property.
 *   
 *  You can control layout property by giving it a table layout, which accepts 
 *  number of columns, cell width and cell height parameters. 
 *  In addition, you can also control your layout by overriding checkbox-list css styles.
 */
@CustomTag('m-checkbox-group')
class CheckboxGroup extends ListBase with Polymer, Observable, Component {
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory CheckboxGroup() {
    return new Element.tag('div', 'm-checkbox-group');
  }
  
  /**
   * Constructor instantiated by the DOM when a CheckboxGroup element has been created.
   */
  CheckboxGroup.created() : super.created() {
    print('CheckboxGroup create');
    //
    allowMultipleSelection = true;
    labelPath = 'label';
    valuePath = 'value';
    valueSeparator = ', ';
    //itemRenderer = "span.m-checkbox-item-renderer";
  }

  /**
   * Create an instance of [itemRenderer].
   */
  @override
  ListItemRenderer instantiateItemRenderer() {
    ListItemRenderer renderer = super.instantiateItemRenderer();
    renderer.onChange.listen(onItemRendererChange);
    return renderer;
  }
  
  /******************
   * Event Handlers *
   ******************/
  
  /**
   * ItemRenderer changed the state
   */
  void onItemRendererChange(CustomEvent event) {
    print('CheckboxGroup.onItemRendererChange');
    if (event.target is Component) {
      toggleSelection((event.target as Component).data);
    }
  }
}