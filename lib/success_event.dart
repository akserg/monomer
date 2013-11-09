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

library monomer_success_event;

import 'dart:html';

/**
 * This event dispatches to inform about success of HttpRequest 
 */
class SuccessEvent extends CustomEvent {
  
  static const String SUCCESS = "success";
  
  /**
   * Create new instance of [SuccessEvent].
   */
  factory SuccessEvent(HttpRequest request, sendData, 
      {bool canBubble: true, bool cancelable: true}) {
    return new CustomEvent(SUCCESS, canBubble:canBubble, cancelable:cancelable, 
        detail:{'request':request, 'data':sendData});
  }
}
