// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void deleteButtonTests() {
  logMessage('Performing POST button tests.');

  group('Testing Delete button:', () {
    DeleteButton button;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      button = new DeleteButton();
      // Suppress comform warning
      button.confirm = false;
      document.body.append(button);
    });
    
    tearDown((){
      button.remove();
    });
    
    test('Do Action', () {
      logMessage('Expect call action method when user click on button');
      
      button.data = dataToSend;
      
      button.onAction.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('action'), reason:'must be action event type');
      });
      
      logMessage('Click on button');
      button.dispatchEvent(new MouseEvent('click'));
    });
  });
}