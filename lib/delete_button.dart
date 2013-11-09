/**
 * Copyright (C) 2013 Sergey Akopkokhyants. All rights reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library monomer_delete_button;

import 'package:polymer/polymer.dart' show Polymer, Observable, CustomTag;
import 'post_button.dart';
import 'component.dart';

/**
 * Delete
 */
@CustomTag('m-delete-button')
class DeleteButton extends PostButton with Polymer, Observable, Component {
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Constructor instantiated by the DOM when a DeleteButton element has been created.
   */
  DeleteButton.created() : super.created() {
    confirm = true;
    confirmMessage = "Do You want to delete the item?";
  }
}