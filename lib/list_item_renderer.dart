// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_list_item_renerer;

/**
 * ListItemRenderer are dedicated to displaying a particular field
 * from the data provider item. 
 */
abstract class ListItemRenderer {
  
  /**
   * Index of rendering data item.
   * Sets by owner.
   */
  int itemIndex;
  
  /**
   * Will equals true if rendering item is first. 
   * Sets by owner.
   */
  bool itemFirst;
  
  /**
   * Will equals true if rendering item is last.
   * Sets by owner.
   */
  bool itemLast;
  
  /**
   * Will equals true if item is odd. 
   */
  bool itemOdd = false;
  
  /**
   * Will equals true if rendering item is selected.
   * Sets by owner.
   */
  bool itemSelected;
}
