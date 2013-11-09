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

library monomer_component;

import 'dart:html' show Element, CustomEvent, Event, EventTarget;
import 'dart:async' show Duration, Timer;

/**
 * The base mixin class for the majority of user-interface objects. 
 */
abstract class Component {

  /***********
   * CONSTANTS
   **********/
  
  static const String SHOW_EVENT = "show";
  static const String HIDE_EVENT = "hide";
  static const String VISIBLE_EVENT = "visible";
  static const String HIDDEN_EVENT = "hidden";
  
  /**************
   * Visibility *
   **************/
  
  /**
   * Whether or not the display object is visible. 
   * Display objects that are not visible are disabled.
   * When setting to [true], the object dispatches a [show] event.
   * When setting to [false], the object dispatches a [hide] event. 
   */
  void setVisible(Element element, bool value) {
    if (value != isVisible(element)) {
      element.style.display = value ? '' : 'none';
      element.attributes['aria-hidden'] = (!value).toString();
      element.dispatchEvent(new CustomEvent(value ? SHOW_EVENT : HIDE_EVENT));
    }
  }
  
  /**
   * Check is [element] visible.
   */
  bool isVisible(Element element) {
    return element.style.display != 'none'; 
  }
  
  /**********
   * Enable *
   **********/
  
  static const List<String> _INPUT_ELEMENTS = const ["input","button","select","textarea"];
  
  /**
   * Set [element] enabled or disabled depends on [value].
   * We can directly manipulate with disabled property of next elements:
   *  - [InputElement],
   *  - [ButtonElement],
   *  - [SelectElement],
   *  - [TextAreaElement]. 
   */
  void setEnabled(element, bool value) {
    assert(element != null);
    assert(value != null);
    // We can only disable element from [_INPUT_ELEMENTS] list of types.
    if (_INPUT_ELEMENTS.contains(element.tagName.toLowerCase())) {
      var disabled = !value;
      element.disabled = disabled;
      element.attributes['aria-disabled'] = "$disabled";
    }
  }
  
  /**
   * Either [element] enabled.
   */
  bool isEnabled(element) {
    assert(element != null);
    if (_INPUT_ELEMENTS.contains(element.tagName)) {
      return !element.disabled;
    }
  }
  
  /**********
   * Styles *
   **********/
  
  /**
   * Add [classes] to [element] with optional [prefix].
   */
  void addClasses(Element element, String classes, [String prefix = '']) {
    if (classes != null) {
      element.classes.add(prefix + classes);
    }
  }
  
  /**
   * Remove [classes] from [element] with optional [prefix].
   */
  void removeClasses(Element element, String classes, [String prefix = '']) {
    if (classes != null) {
      element.classes.remove(prefix + classes);
    }
  }
  
  /**
   * Swap [oldClasses] classes of [elemenet] to [newClasses] with optional [prefix].
   */
  void swapClasses(Element element, String oldClasses, String newClasses, [String prefix = '']) {
    removeClasses(element, oldClasses, prefix);
    addClasses(element, newClasses, prefix);
  }
  
  /**
   * Togle [classes] depends on [value] of [element] with optional [prefix].
   */
  void toggleClasses(Element element, bool value, String classes, [String prefix = '']) {
    if (value) {
      addClasses(element, classes, prefix);
    } else {
      removeClasses(element, classes, prefix);
    }
  }
  
  /**
   * Clear classes of [element].
   */
  void clearClasses(Element element) {
    element.classes.clear();
  }
  
  /*************
   * CallLater *
   *************/
  
  static const _callLaterDuration = const Duration(milliseconds: 200);
  
  /**
   * Queue for function calling in [callLater].
   */
  List<Function> queue = new List<Function>();
  
  /**
   * Execute [function] code later. Optional parameter [duration] equals 200ms 
   * by default.
   */
  void callLater(Function function, [Duration duration = _callLaterDuration]) {
    // Check is function in queue
    if (!queue.contains(function)) {
      // Add new one
      queue.add(function);
      // Run timer
      new Timer(duration, (){
        try {
          // Execute function
          function();
        } on Exception catch(e) {
          print(e);
        } finally {
          // Remove function from queue
          queue.remove(function);
        }
      });
    } else {
      print('Found function duplicate');
    }
  }
  
  /**********
   * Events *
   **********/
  
  /**
   * Cancel dispatching specified Event.
   */
  void cancelEvent(Event e) {
    EventTarget t = e.target;
    // We still dispathching events of [InputELement] 
    if (t != null && t is Element && t.nodeName == 'input')
      return;

    /**
     * Check is defaultPrevented switched on to prevent defaults.
     */
    if (e.defaultPrevented) { 
      e.preventDefault(); 
    } else { 
      e.stopImmediatePropagation(); 
    }

    /**
     * Stop any propagation of event.
     */
    e.stopPropagation();
  }
}