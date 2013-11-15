// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_component;

import 'dart:html';
import 'dart:async';

/**
 * The base mixin class for the majority of user-interface objects. 
 */
abstract class Component {

  /***********
   * CONSTANTS
   **********/
  
  static const String ACTION_EVENT = 'action';
  static const String VISIBLE_EVENT = "visible";
  static const String INCLUDE_IN_LAYOUT_EVENT = "includeInLayout";
  static const String FAULT_EVENT = 'fault';
  static const String VALIDATE_EVENT = 'validate';
  
  /**************
   * Visibility *
   **************/
  
  /**
   * Whether or not the display object is visible. 
   * Display objects that are not visible are disabled.
   * When setting to [true], the object dispatches a [show] event.
   * When setting to [false], the object dispatches a [hide] event. 
   */
  static void setVisible(Element element, bool value) {
    if (value != isVisible(element)) {
      element.style.display = value ? '' : 'none';
      element.attributes['aria-hidden'] = (!value).toString();
      element.dispatchEvent(new CustomEvent(VISIBLE_EVENT, detail:value));
    }
  }
  
  /**
   * Check is [element] visible.
   */
  static bool isVisible(Element element) {
    return element.style.display != 'none'; 
  }

  /**
   * Whether or not the display object is inclide in layout on page.
   */
  static void setIncludeInLayout(Element element, bool value) {
    element.style.visibility = value ? 'visible' : 'hidden';
    element.dispatchEvent(new CustomEvent(INCLUDE_IN_LAYOUT_EVENT, detail:value));
  }

  /**
   * Check is [element] inluded in layuout on page.
   */
  static bool isIncludeInLayout(Element element) {
    return element.style.visibility == 'visible'; 
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
  static void setEnabled(element, bool value) {
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
  static bool isEnabled(element) {
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
  static void addClasses(Element element, String classes, [String prefix = '']) {
    if (classes != null) {
      element.classes.add(prefix + classes);
    }
  }
  
  /**
   * Remove [classes] from [element] with optional [prefix].
   */
  static void removeClasses(Element element, String classes, [String prefix = '']) {
    if (classes != null) {
      element.classes.remove(prefix + classes);
    }
  }
  
  /**
   * Swap [oldClasses] classes of [elemenet] to [newClasses] with optional [prefix].
   */
  static void swapClasses(Element element, String oldClasses, String newClasses, [String prefix = '']) {
    removeClasses(element, oldClasses, prefix);
    addClasses(element, newClasses, prefix);
  }
  
  /**
   * Togle [classes] depends on [value] of [element] with optional [prefix].
   */
  static void toggleClasses(Element element, bool value, String classes, [String prefix = '']) {
    if (value) {
      addClasses(element, classes, prefix);
    } else {
      removeClasses(element, classes, prefix);
    }
  }
  
  /**
   * Clear classes of [element].
   */
  static void clearClasses(Element element) {
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
  
  /******** 
   * Data *
   ********/
  
  /**
   * Arbitrary information.
   */
  dynamic data;
}