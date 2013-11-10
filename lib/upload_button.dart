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

library monomer_upload_button;

import 'dart:html' show InputElement, FileUploadInputElement, Event, MouseEvent, window, HttpRequest, FormData, File, ProgressEvent, CustomEvent;
import 'dart:convert' show JSON;
import 'package:polymer/polymer.dart' show Polymer, Observable, CustomTag, observable, published;
import 'post_button.dart';
import 'src/component.dart';

/**
 * Delete
 */
@CustomTag('m-upload-button')
class UploadButton extends PostButton with Polymer, Observable, Component {
  
  /**************
   * Properties *
   **************/
  @published
  String fileTypes;
  
  /**
   * This attribute supplies browsers with a hint about what filetypes its 
   * element will accept.
   * 
   * Accepts a comma separated list of file types. Valid file types can be any 
   * of the following.
   * 
   * - The string audio/\* indicates any audio file is allowed.
   * - The string video/\* indicates any video file is allowed.
   * - The string image/\* indicates any image file is allowed.
   * - A valid [type] with no attributes.
   * - A file extension starting with a . (period).
   * - Duplicates are not allowed (case insensitive).
   * 
   * Examples:
   * - <input type="file" accept="audio/\*" /> - Indicates that audio files are accepted.
   * - <input type="file" accept="image/png, image/gif" /> - Indicates that both PNG and GIF file formats are accepted.
   */
  @published
  @observable
  String accept = "*/*";
  acceptChanged(old) {
    if (fileInput != null) {
      fileInput.accept = accept;
    }
  }
  
  /**
   * The capture attribute is a boolean attribute that, if specified, indicates 
   * that the capture of media directly from the device's environment using a 
   * media capture mechanism is preferred.
   * 
   * The capture attribute applies to input elements when the type attribute's 
   * value is file and its accept attribute is specified. If the accept 
   * attribute's value is set to a MIME type that has no associated capture 
   * control type, the user agent acts as if there was no capture attribute.
   * 
   * Examples:
   * - <input type="file" accept="image/\*" capture> - Indicates that image files are accepted to be captured.
   * - <input type="file" accept="video/\*" capture> - Indicates that video files are accepted to be captured.
   * - <input type="file" accept="audio/\*" capture> - Indicates that audio files are accepted to be captured.
   */
  @published
  @observable
  bool capture =  false;
  captureChanged(old) {
    if (fileInput != null) {
      fileInput.attributes['capture'] = capture.toString();
    }
  }
  
  /**
   * Uploading progress value
   */
  @observable
  int progress = 0;
  
  /**
   * Instance of [HttpRequest] using to upload files. 
   */
  HttpRequest request;
  
  /**
   * Get File upload input element.
   */
  InputElement fileInput;
  
  /******************
   * Initialisation *
   ******************/
  
  /**
   * Constructor instantiated by the DOM when a UploadButton element has been created.
   */
  UploadButton.created() : super.created() {
    fileInput = new InputElement();
    fileInput.type = "file";
    //
    fileInput.accept = accept;
    fileInput.attributes['capture'] = capture.toString();
    //
    fileInput.style.left = "-500px";
    fileInput.style.position = "absolute";
    fileInput.style.top = "-0px";
    //
    fileInput.onChange.listen(onFileSelected);
  }

  void enterView() {
    super.enteredView();
    //
    this.parent.append(fileInput);
  }
  
  void leftView() {
    super.leftView();
    //
    fileInput.remove();
  }
  
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

    if (url != null) {
      fileInput.dispatchEvent(new MouseEvent('click'));
      cancelEvent(e);
    }
  }
  
  void onFileSelected(Event e) {
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
    
    request = new HttpRequest();
    request.timeout = 3600000;
    request.onLoad.listen(onUploadComplete);
    request.onError.listen(onUploadFault);
    request.onTimeout.listen(onUploadFault);
    //
    request.upload.onProgress.listen(onUploadProgress);
    request.upload.onTimeout.listen(onUploadFault);
    request.upload.onError.listen(onUploadFault);
    //
    int i = 0;
    FormData fd = new FormData();
    for (Iterator<File> iter = fileInput.files.iterator; iter.moveNext();) {
      fd.append("file${i++}", iter.current.name);
    }
    //
    fd.append("formModel", JSON.encode(dataToSend));
    //
    request.open("POST", url);
    request.send(fd);
  }
  
  /**
   * Error handler.
   */
  void onUploadFault(ProgressEvent event) {
    request = null;
    window.alert('Upload failed');
  }
  
  /**
   * Upload Progress handler
   */
  void onUploadProgress(ProgressEvent event) {
    if (event.lengthComputable) {
      progress = (event.loaded * 100 / event.total).round();
    }
  }
  
  /**
   * Upload complete handler.
   */
  void onUploadComplete(ProgressEvent event) {
    if (event.target != null && event.target == request) {
      if (request.status == 200) {
        value = request.responseText;
      } else {
        window.alert(request.statusText);
        return;
      }
    } else {
      value = "";
    }
    //
    request = null;
    //
    dispatchEvent(new CustomEvent('action', detail:event));
  }
}