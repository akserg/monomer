// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_checkbox_group;

import 'dart:html';

import 'package:polymer/polymer.dart';
import "package:log4dart/log4dart.dart";

import 'item_renderer.dart';
import 'list_base.dart';
import 'component.dart';

/**
 *  CheckBoxGroup is inherited from ListBase, but by default it allows multiple 
 *  selection and automatically provides comma separated values as value property.
 */
@CustomTag('m-checkbox-group')
class CheckBoxGroup extends ListBase with Polymer, Observable, Component {
  
  static final _logger = LoggerFactory.getLoggerFor(CheckBoxGroup);
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory CheckBoxGroup() {
    return new Element.tag('div', 'm-checkbox-group');
  }
  
  /**
   * Constructor instantiated by the DOM when a CheckBoxGroup element has been created.
   */
  CheckBoxGroup.created() : super.created() {
    allowMultipleSelection = true;
    labelPath = 'label';
    valuePath = 'value';
    valueSeparator = ',';
    itemRenderer = "span.m-checkbox";
  }

  /**
   * Create an instance of [itemRenderer].
   */
  @override
  ItemRenderer instantiateItemRenderer() {
    ItemRenderer renderer = super.instantiateItemRenderer();
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
    _logger.debug('onItemRendererChange $event');
    if (event.target is ItemRenderer) {
      ItemRenderer item = event.target as ItemRenderer;
      select(item.data, item.itemSelected);
    }
  }
}