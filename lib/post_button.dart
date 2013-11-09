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

library monomer_post_button;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart' show Polymer, Observable, CustomTag, observable, published;
import 'button.dart';
import 'component.dart';
import 'success_event.dart';
import 'ajax.dart';

/**
 * PostButton helps make AJAX POST request when user click on the button. 
 * Developers can specify [confirmMessage] to alerts user before do the real 
 * request. Property [url] must not be null to perform POST request or original 
 * action will be executed. 
 */
@CustomTag('m-post-button')
class PostButton extends Button with Polymer, Observable, Component {
  
  /**************
   * Properties *
   **************/

  /**
   * Execute that function after success result returns back.
   */
  @published
  EventListener onSuccess;
  
  /**
   * Execute that function after fault result returns back.
   */
  @published
  EventListener onFault;
  
  /**
   * Progress event listener.
   */
  @published
  EventListener onProgress;
  
  /**
   * [String] telling the server the desired response format.
   *
   * Default is `String`.
   * Other options are one of 'arraybuffer', 'blob', 'document', 'json',
   * 'text'. Some newer browsers will throw NS_ERROR_DOM_INVALID_ACCESS_ERR if
   * `responseType` is set while performing a synchronous request.
   */
  @published
  String responseType;
  
  /**
   * Specify a particular MIME type (such as `text/xml`) desired for the
   * response.
   *
   * This value must be set before the request has been sent. See also the list
   * of [common MIME types](http://en.wikipedia.org/wiki/Internet_media_type#List_of_common_media_types)
   */
  @published
  String mimeType;
  
  /**
   * Flag saying use credentials.
   */
  @published
  bool withCredentials = false;
  
  /**
   * Optional Headers data.
   */
  @published
  Map<String, String> requestHeaders;
  
  /**
   * Arbitrary information to send.
   */
  @published
  dynamic postData;
  
  /**
   * URL of POST request.
   */
  @published
  String url;
  
  /**
   * Flag to trigger confirm message.
   */
  @published
  bool confirm = false;
  
  /**
   * Message to confirm the action.
   */
  @published
  String confirmMessage;
  
  /**
   * Arbitrary data to merge before send POST request.
   */
  @published
  dynamic mergeData;
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Constructor instantiated by the DOM when a PostButton element has been 
   * created.
   */
  PostButton.created() : super.created();
  
  
  /******************
   * Event Handlers *
   ******************/
  
  /**
   * Click handler to do the action with optional data.
   * This method prevents any event dispatching.
   */
  @override
  void onClickHandler(Event e) {
    // Confirm action if necessary
    if (confirm) {
      if (!window.confirm(confirmMessage)) {
        return;
      }
    }
    
    // If URL is not specified do the standard action.
    if (url == null) {
      super.onClickHandler(e);
    } else {
      // Check is data to send exists?
      dynamic dataToSend;
      if (postData != null) {
        dataToSend = postData;
      } else if (data != null) {
        dataToSend = data;
      } else {
        return;
      }
      
      // Mix original data with merging 
      if (mergeData != null) {
        dataToSend.addAll(mergeData);
      }
      
      // Send data if dataToSend has 'toJson' method
      if (isSerializable(dataToSend)) {
        HttpRequest.request(url, method:'POST', withCredentials:withCredentials, 
            responseType:responseType, mimeType:mimeType, 
            requestHeaders:requestHeaders, sendData:JSON.encode(dataToSend), 
            onProgress:onProgress).then((HttpRequest request) {
              onSuccess(new SuccessEvent(request, dataToSend));
            }, onError:onFault);
      }
    }
  }
}