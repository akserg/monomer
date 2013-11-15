// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_delete_button;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'post_button.dart';
import 'component.dart';

/**
 * DeleteButton is PostButton with confitm message.
 */
@CustomTag('m-delete-button')
class DeleteButton extends PostButton with Polymer, Observable, Component {
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory DeleteButton() {
    return new Element.tag('button', 'm-delete-button');
  }
  
  /**
   * Constructor instantiated by the DOM when a DeleteButton element has been created.
   */
  DeleteButton.created() : super.created() {
    confirm = true;
    confirmMessage = "Do You want to delete the item?";
  }
}