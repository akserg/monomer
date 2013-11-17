// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

/**
 * Mock implementation of Ajax library.
 */
class AjaxMock extends Mock implements Ajax {
  
  static const duration = const Duration(milliseconds: 200);
  
  /**
   * Returns data.
   */
  dynamic data;
  
  /**
   * POST data to specified url.
   */
  Future post(String url, {
              bool withCredentials:false, 
              String responseType:null, 
              String mimeType:null, 
              Map<String, String> requestHeaders:null, 
              dynamic sendData:null}) {
    Completer completer = new Completer(); 
    // Run timer
    new Timer(duration, (){
      // Execute function
      postFunction(completer);
    });
    return completer.future;
  }
  
  /**
   * POST response hahndler.
   */
  void postFunction(Completer completer) {
    HttpRequestMock request = new HttpRequestMock();
    request.readyState = HttpRequest.DONE;
    request.status = 200;
    request.response = data;
    request.responseText = JSON.encode(data);
    completer.complete(request);
  }
}

/**
 * Mock implementation of Ajax library generates exceptions.
 */
class AjaxErrorMock extends AjaxMock {

  /**
   * POST error response handler.
   */
  @override
  void postFunction(Completer completer) {
    HttpRequestMock request = new HttpRequestMock();
    request.readyState = HttpRequest.DONE;
    request.status = 404;
    request.response = null;
    request.responseText = "Not Found";
    completer.completeError(request);
  }
}

/**
 * Mock version of HttpRequest
 */
class HttpRequestMock {
  
  /**
   * Indicator of the current state of the request:
   *
   * <table>
   *   <tr>
   *     <td>Value</td>
   *     <td>State</td>
   *     <td>Meaning</td>
   *   </tr>
   *   <tr>
   *     <td>0</td>
   *     <td>unsent</td>
   *     <td><code>open()</code> has not yet been called</td>
   *   </tr>
   *   <tr>
   *     <td>1</td>
   *     <td>opened</td>
   *     <td><code>send()</code> has not yet been called</td>
   *   </tr>
   *   <tr>
   *     <td>2</td>
   *     <td>headers received</td>
   *     <td><code>sent()</code> has been called; response headers and <code>status</code> are available</td>
   *   </tr>
   *   <tr>
   *     <td>3</td> <td>loading</td> <td><code>responseText</code> holds some data</td>
   *   </tr>
   *   <tr>
   *     <td>4</td> <td>done</td> <td>request is complete</td>
   *   </tr>
   * </table>
   */
  int readyState;
  
  /**
   * The data received as a reponse from the request.
   *
   * The data could be in the
   * form of a [String], [ByteBuffer], [Document], [Blob], or json (also a
   * [String]). `null` indicates request failure.
   */
  Object response;
  
  /**
   * The response in String form or empty String on failure.
   */
  String responseText;
  
  /**
   * [String] telling the server the desired response format.
   *
   * Default is `String`.
   * Other options are one of 'arraybuffer', 'blob', 'document', 'json',
   * 'text'. Some newer browsers will throw NS_ERROR_DOM_INVALID_ACCESS_ERR if
   * `responseType` is set while performing a synchronous request.
   *
   * See also: [MDN responseType](https://developer.mozilla.org/en-US/docs/DOM/XMLHttpRequest#responseType)
   */
  String responseType;
  
  /**
   * The http result code from the request (200, 404, etc).
   * See also: [Http Status Codes](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
   */
  int status;
  
  /**
   * The request response string (such as \"200 OK\").
   * See also: [Http Status Codes](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
   */
  String statusText;
  
  /**
   * Length of time before a request is automatically terminated.
   *
   * When the time has passed, a [TimeoutEvent] is dispatched.
   *
   * If [timeout] is set to 0, then the request will not time out.
   *
   * ## Other resources
   *
   * * [XMLHttpRequest.timeout]
   * (https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest#timeout)
   * from MDN.
   * * [The timeout attribute]
   * (http://www.w3.org/TR/XMLHttpRequest/#the-timeout-attribute)
   * from W3C.
   */
  int timeout;
  
  /**
   * True if cross-site requests should use credentials such as cookies
   * or authorization headers; false otherwise.
   *
   * This value is ignored for same-site requests.
   */
  bool withCredentials;
}