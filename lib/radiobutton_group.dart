// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_radiobutton_group;

import 'dart:html';

import 'package:polymer/polymer.dart';
import "package:log4dart/log4dart.dart";

import 'item_renderer.dart';
import 'list_base.dart';
import 'component.dart';

/**
 *  RadioButtonGroup is inherited from ListBase, but by default it allows one 
 *  selection and automatically provides value property.
 */
@CustomTag('m-radiobutton-group')
class RadioButtonGroup extends ListBase with Polymer, Observable, Component {
  
  static final _logger = LoggerFactory.getLoggerFor(RadioButtonGroup);
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory RadioButtonGroup() {
    return new Element.tag('div', 'm-radiobutton-group');
  }
  
  /**
   * Constructor instantiated by the DOM when a RadioButtonGroup element has been created.
   */
  RadioButtonGroup.created() : super.created() {
    allowMultipleSelection = false;
    labelPath = 'label';
    valuePath = 'value';
    valueSeparator = ',';
    itemRenderer = "span.m-radiobutton";
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
    _logger.debug('onItemRendererChange ${event.target} ${event.detail}');
    // We triggering events comes only from selected controls
    if (event.target is ItemRenderer) {
      ItemRenderer item = event.target as ItemRenderer;
      select(item.data, item.itemSelected);
    }
  }
}