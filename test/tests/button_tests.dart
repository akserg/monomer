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

part of monomer_tests;

void buttonTests() {
  logMessage('Performing button tests.');

  group('Testing button:', () {
    Button button;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      button = new Element.tag('button', 'm-button');
      document.body.append(button);
    });
    
    tearDown((){
      button.remove();
    });
    
    test('Do Action with data', () {
      logMessage('Expect call action method when user click on button');
      
      button.data = dataToSend;
      
      button.onAction.listen((event) {
        logMessage('Called action method');
        expect(event, new isInstanceOf<CustomEvent>());
      });
      
      logMessage('Click on button');
      button.dispatchEvent(new MouseEvent('click'));
    });
  });
}

void postButtonTests() {
  logMessage('Performing POST button tests.');

  group('Testing POST button:', () {
    PostButton button;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      button = new Element.tag('button', 'm-post-button');
      document.body.append(button);
    });
    
    tearDown((){
      button.remove();
    });
    
    test('Do Action with data', () {
      logMessage('Expect call action method when user click on POST button');
      
      button.data = dataToSend;
      
      button.onAction.listen((event) {
        logMessage('Called action method');
        expect(event, new isInstanceOf<CustomEvent>());
      });
      
      logMessage('Click on button');
      button.dispatchEvent(new MouseEvent('click'));
    });
    
    test('POST data', (){
      logMessage('Expect call action method when user click on POST button');
      
      button.data = dataToSend;
      
      button.action = (data) {
        logMessage('Called action method');
        expect(data, equals(dataToSend));
      };
      
      logMessage('Click on button');
      button.dispatchEvent(new MouseEvent('click'));
    });
  });
}
