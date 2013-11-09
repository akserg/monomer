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

library monomer_ajax;

import 'dart:html';
import 'dart:async';
import 'dart:mirrors';

/**
 * The function check has [instance] the method [toJson].
 */
bool isSerializable(instance) {
  assert (instance != null);
  ClassMirror clazz = reflect(instance).type;
  return clazz.declarations.containsKey(const Symbol('toJson'));
}

/**
 * Send POST request with [formData] to [url].
 */
Future<HttpRequest> postRequest(String url, String formData, 
    {Map<String, String> requestHeaders:null, bool withCredentials, 
    String responseType, void onProgress(ProgressEvent e)}) {
  // Check headers
  if (requestHeaders == null) {
    requestHeaders = {};
  }
  // Add content type if absent
  requestHeaders.putIfAbsent('Content-Type',
      () => 'application/x-www-form-urlencoded; charset=UTF-8');
  // Send POSt request on url with headers, credentials and data
  return HttpRequest.request(url, method: 'POST', requestHeaders: requestHeaders, 
      sendData: formData);
}
