// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_has_data;

/**
 * Interface marks [Component] might has a data.
 */
abstract class HasData {
  
  /**
   * Arbitrary information.
   */
  dynamic data;
}