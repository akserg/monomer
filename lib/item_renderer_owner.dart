// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_item_renderer_owner;

/**
 * The ItemRendererOwner interface defines the basic set of APIs that a class 
 * must implement to  support items renderers. 
 * A class  that implements the ItemRendererOwner interface is called the host 
 * component of the item renderer.
 */
abstract class ItemRendererOwner {
  
  /**
   * Returns the String that the item renderer displays for the given data object.
   * If the ItemRendererOwner has a non-null [labelFunction] property, it applies 
   * the function to the data object. 
   * Otherwise, the method extracts the contents of the field specified by the 
   * [dataField] property, or gets the string value of the data object.
   * If the method cannot convert the parameter to a String, it returns a
   * single space.
   */
  String itemToLabel(data);
}