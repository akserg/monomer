// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_ajax;

import 'dart:async';
import 'dart:html';

/**
 * Set of utilitu methods to make AJAX requests.
 */
class Ajax {
 
  /**
   * POST data to specified url.
   */
  Future post(String url, {
              bool withCredentials:false, 
              String responseType:null, 
              String mimeType:null, 
              Map<String, String> requestHeaders:null, 
              dynamic sendData:null}) {
    
    return HttpRequest.request(url, 
        method:'POST', 
        withCredentials:withCredentials, 
        responseType:responseType, 
        mimeType:mimeType, 
        requestHeaders:requestHeaders, 
        sendData:sendData);
  }
}