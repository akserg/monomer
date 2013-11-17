// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_form;

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';

import 'component.dart';
import 'validator.dart';
import 'ajax.dart';

/**
 * The Form container lets you control the layout of a form, mark form fields as 
 * required, handle error messages, and bind your form data to the Dart data 
 * model to perform data checking and validation.
 */
@CustomTag('m-form')
class Form extends DivElement with Polymer, Observable, Component {
  
  /*************
   * Constants *
   *************/

  /**
   * Provider of 'action' events.
   */
  static const EventStreamProvider<Event> _actionEvent = const EventStreamProvider<Event>(Component.ACTION_EVENT);
  
  /**
   * Provider of 'visible' events.
   */
  static const EventStreamProvider<Event> _visibleEvent = const EventStreamProvider<Event>(Component.VISIBLE_EVENT);
  
  /**
   * Provider of 'includeInLayout' events.
   */
  static const EventStreamProvider<Event> _includeInLayoutEvent = const EventStreamProvider<Event>(Component.INCLUDE_IN_LAYOUT_EVENT);
  
  /**
   * Provider of 'success' events.
   */
  static const EventStreamProvider<Event> _successEvent = const EventStreamProvider<Event>(Component.SUCCESS_EVENT);
  
  /**
   * Provider of 'fault' events.
   */
  static const EventStreamProvider<Event> _faultEvent = const EventStreamProvider<Event>(Component.FAULT_EVENT);
  
  /**************
   * Properties *
   **************/
  
  bool get applyAuthorStyles => true;
  
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
   * Arbitrary information stored in Form.
   */
  @published
  dynamic data;
  
  /**
   * Result of last POST request
   */
  @published
  dynamic result;
  
  /**
   * Arbitrary data to merge before send POST request.
   */
  @published
  dynamic mergeData;
  
  /**
   * Flag tells merge result of POST request back to data.
   */
  @published
  bool mergeResult = true;
  
  /**
   * URL of POST request.
   */
  @published
  String url;
  
  /**
   * Message about success.
   */
  @published
  String successMessage;

  /**
   * Arbitrary data to merge after result of POST request returns back.
   */
  @published
  dynamic clearData;
  
  /**
   * Return list of validators in form.
   */
  List<Validator> get validators => this.querySelectorAll("[data-validator='true'");
  
  /**
   * Instance of AJAX manager.
   */
  Ajax ajax = new Ajax();
  
  /**********
   * Events *
   **********/
  
  /**
   * Stream of 'action' events handled by this element.
   */
  ElementStream<Event> get onAction => _actionEvent.forElement(this);
  
  /**
   * Stream of 'visible' events handled by this element.
   */
  ElementStream<Event> get onVisible => _visibleEvent.forElement(this);
  
  /**
   * Stream of 'includeInLayout' events handled by this element.
   */
  ElementStream<Event> get onIncludeInLayout => _includeInLayoutEvent.forElement(this);
  
  /**
   * Stream of 'success' events handled by this element.
   */
  ElementStream<Event> get onSuccess => _successEvent.forElement(this);
  
  /**
   * Stream of 'fault' events handled by this element.
   */
  ElementStream<Event> get onFault => _faultEvent.forElement(this);
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Default factory constructor.
   */
  factory Form() {
    return new Element.tag('div', 'm-form');
  }
  
  /**
   * Constructor instantiated by the DOM when a Form element has been created.
   */
  Form.created():super.created() {
    onSuccess.listen(onSuccessHandler);
    onKeyUp.listen((KeyboardEvent e) {
      if (e.target is TextAreaElement)
        return;
      if (e.keyCode == KeyCode.ENTER) {
        onSubmitHandler(e);
      }
    });
    onSubmit.listen(onSubmitHandler);
    //
    InputElement input = this.querySelector("input[type=submit]");
    if (input != null) {
      input.onClick.listen(onSubmitHandler); 
    }
    ButtonElement button = this.querySelector("button[type=submit]");
    if (button != null) {
      button.onClick.listen(onSubmitHandler);
    }
  }
  
  /**
   * Submit Event handler.
   * First it validates form items. If all form items valid it calls 
   * [preparePostData] and make an Http POST request.
   * 
   */
  void onSubmitHandler(Event e) {
    cancelEvent(e);
    print('onSubmitHandler');
    //
    if (isValid()) {
      var dataToSend = this.preparePostData();
      print('Data to send $dataToSend');
      
      // If URL is not specified do the standard action.
      if (url == null) {
        dispatchEvent(new CustomEvent(Component.ACTION_EVENT, detail:dataToSend));
      } else {
        // Send data
        ajax.post(url, 
            withCredentials:withCredentials ,
            responseType:responseType , 
            mimeType:mimeType , 
            requestHeaders:requestHeaders , 
            sendData:JSON.encode(dataToSend))
        ..catchError((Event error){
          dispatchEvent(new CustomEvent(Component.FAULT_EVENT, detail:error));
        })
        ..then((HttpRequest request) {
          dispatchEvent(new CustomEvent(Component.SUCCESS_EVENT, detail:request));
        });
      }
    }
  }
  
  /**
   * Prepare data to send. The [mergeData] will merged in data to send if exists.
   */
  dynamic preparePostData() {
    dynamic dataToSend = data;
    
    // Mix original data with merging 
    if (mergeData != null) {
      dataToSend.addAll(mergeData);
    }

    return dataToSend;
  }
  
  
  /**
   * Success event handler. 
   * Result can be merged back into data.
   */
  void onSuccessHandler(CustomEvent e) {

    HttpRequest request = e.detail;
    result = JSON.decode(request.responseText);

    if (mergeResult) {
      // Mergeing
      for (var index in result) {
        data[index] = result[index];
      }
    }

    if (clearData != null) {
      for (var index in clearData) {
        data[index] = clearData[index];
      }
    }

    if (successMessage != null) {
      window.alert(successMessage);
    }

    dispatchEvent(new CustomEvent(Component.ACTION_EVENT, detail:result));
  }
  
  /**
   * Validate Form. That process runs each [Validator]'s isValid method.
   * The validation returns false if find first invalid field or true if
   * all form fields ara valid.
   */
  bool isValid() {
    for (Validator validator in validators) {
      print('Validator is $validator');
      if (!validator.isValid()) {
        return false;
      }
    }
    return true;
  }
}
