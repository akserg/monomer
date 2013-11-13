// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

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
