// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_has_action;

/**
 * Interface marks [Component] can do some action.
 */
abstract class HasAction {
  
  /**
   * Do action with optional [data].
   */
  Function action;
}