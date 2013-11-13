// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

/**
 * Mock version of [HttpRequest] class.
 */
class MockHttpRequest extends Mock implements HttpRequest {
  
  Map<String, String> responseHeaders;
  
  int readyState;
  
  Object response;
  
  String responseText;
  
  String responseType;
  
  Document responseXml;
  
  int status;
  
  String statusText;
  
  int timeout;
  
  HttpRequestUpload upload;
  
  bool withCredentials;
  
  Stream<ProgressEvent> onReadyStateChange;
  
  Stream<ProgressEvent> onAbort;
  
  Stream<ProgressEvent> onError;
  
  Stream<ProgressEvent> onLoad;
  
  Stream<ProgressEvent> onLoadEnd;
  
  Stream<ProgressEvent> onLoadStart;
  
  Stream<ProgressEvent> onProgress;
  
  Stream<ProgressEvent> onTimeout;
  
  Events on;
  
  factory MockHttpRequest() {
    return new MockHttpRequest();
  }
  
  void abort() {
    
  }
  
  String getAllResponseHeaders() {
    
  }
  
  String getResponseHeader(String header) {
    
  }
  
  void open(String method, String url, {bool async, String user, String password}) {
    
  }
  
  void overrideMimeType(String override) {
    
  }
  
  void send([data]) {
    
  }
  
  void setRequestHeader(String header, String value) {
    
  }
  
  void addEventListener(String type, EventListener listener, [bool useCapture]) {
    
  }
  
  bool dispatchEvent(Event event) {
    
  }
  
  void removeEventListener(String type, EventListener listener, [bool useCapture]) {
    
  }
}