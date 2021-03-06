// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_list_utility;

import 'dart:mirrors';

/**
 * Utility functions for List.
 */
class Utility {
  
  /**
   * Collect values from [list] items following by [valuePath].
   */
  static List getValues(List list, String valuePath) {
    if (valuePath == null) {
      return list;
    } else {
      List result = [];
      list.forEach((item){
        try {
          var value = getValue(item, valuePath);
          result.add(value);
        } on Exception catch(e) {
          print(e);
        }
      });
      return result;
    }
  }
  
  /**
   * Find intersecting values in [list] and [values].
   */
  static List intersect(List list, String valuePath, List values) {
    List result = [];
    values.forEach((item){
      var value = getValue(item, valuePath);
      if (value != null) {
        var match = getMatch(list, valuePath, value);
        if (match != null) {
          result.add(match);
        }
      }
    });
    return result;
  }
  
  /**
   * Find [value] in [valuePath] matching items in [list].
   */
  static dynamic getMatch(List list, String valuePath, dynamic value) {
    return list.firstWhere((item){
      var dataItem = item;
      if (valuePath != null) {
        dataItem = getValue(item, valuePath);
      }
      if (dataItem == value) {
        return true;
      }
      return false;
    }, orElse:() => null);
  }
  
  /**
   * Return value of [item] in [valuePath].
   */
  static dynamic getValue(dynamic item, String valuePath) {
    assert(item != null);
    if (valuePath == null || valuePath.trim().length == 0) {
      return item;
    }
    try {
      int indx = valuePath.indexOf(".");
      if (item is Map) {
        // This is Map - process key:value pairs
        if (indx == -1) {
          // Just get map element by key
          return item[valuePath];
        } else {
          // Get chain
          dynamic child = item[valuePath.substring(0, indx)];
          // Process chain
          return child == null ? null : getValue(child, valuePath.substring(indx + 1));
        }
      } else {
        // This is object - process by property name
        InstanceMirror inst = reflect(item);
        if (indx == -1) {
          // We reached last chain in valuePath
          InstanceMirror field = inst.getField(stringAsSymbol(valuePath));
          return field == null ? null : field.reflectee;
        } else {
          InstanceMirror field = inst.getField(stringAsSymbol(valuePath.substring(0, indx)));
          // we have other chains in valuePath - need recursion
          return field == null ? null : getValue(field.reflectee, valuePath.substring(indx + 1));
        }
      }
    } on Exception catch(e) {
      print(e);
    }
    return null;
  }
  
  /**
   * Return value of [item] in [valuePath].
   */
  static void setValue(dynamic item, String valuePath, dynamic value) {
    assert(item != null);
    assert(valuePath != null);
    try {
      int indx = valuePath.indexOf(".");
      if (item is Map) {
        if (indx == -1) {
          item[valuePath] = value;
        } else {
          // Get chain
          dynamic child = item[valuePath.substring(0, indx)];
          // Process chain
          setValue(child, valuePath.substring(indx + 1), value);
        }
      } else {
        InstanceMirror inst = reflect(item);
        if (indx == -1) {
          // We reached last chain in valuePath
          inst.setField(stringAsSymbol(valuePath), value);
        } else {
          InstanceMirror field = inst.getField(stringAsSymbol(valuePath.substring(0, indx)));
          // we have other chains in valuePath - need recursion
          setValue(field.reflectee, valuePath.substring(indx + 1), value);
        }
      }
    } on Exception catch(e) {
      print(e);
    }
    return null;
  }
  
  /**
   * Sort [values] with [sortPath].
   * The [sortPath] must has valuePath and optional [desc] or [asc] parameter.  
   */
  static List sort(List values, String sortPath) {
    String valuePath;
    bool desc = false;
    //
    List sorts = sortPath.split(' ');
    sorts = sorts.takeWhile((String str) => str.trim().length > 0).toList();
    if (sorts.length > 0) {
      valuePath = sorts[0];
      if (sorts.length > 1) {
        desc = sorts[1].toLowerCase() == "desc";
      }
      //
      values.sort(desc ? 
          (a, b) => compareValues(b, a, valuePath) : 
          (a, b) => compareValues(a, b, valuePath));
    }
    return values;
  }
  
  /**
   * Compare values of [a] and [b] folowing by [valuePath]. 
   */
  static int compareValues(a, b, String valuePath) {
    var aValue = getValue(a, valuePath),
        bValue = getValue(b, valuePath);
    
    if (aValue is Comparable) {
      return aValue.compareTo(bValue);
    } else if (aValue is bool) {
      return aValue && aValue == bValue ? 0 : -1;
    } else {
      throw new Exception("Can not compare $a and $b");
    }
  }
}

String symbolAsString(Symbol symbol) => MirrorSystem.getName(symbol);

Symbol stringAsSymbol(String string) => new Symbol(string);

