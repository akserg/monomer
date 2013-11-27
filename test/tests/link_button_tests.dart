// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void linkButtonTests() {
  logMessage('Performing linkButton tests.');

  group('Testing linkButton:', () {
    LinkButton linkButton;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      linkButton = new LinkButton();
      document.body.append(linkButton);
    });
    
    tearDown((){
      linkButton.remove();
    });
    
    test('Do Action', () {
      logMessage('Expect call action method when user click on linkButton');
      
      linkButton.data = dataToSend;
      
      linkButton.onAction.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('action'), reason:'must be action event type');
      });
      
      logMessage('Click on linkButton');
      linkButton.dispatchEvent(new MouseEvent('click'));
    });
    
    test('Do Visible', () {
      logMessage('Expect make linkButton visible or invisible');
      
      linkButton.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(linkButton.style.display, equals(''), reason:'must be visible');
        } else {
          expect(linkButton.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set linkButton invisible');
      Component.setVisible(linkButton, false);
      logMessage('Set linkButton visible');
      Component.setVisible(linkButton, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude linkButton from layout');
      
      linkButton.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>());
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(linkButton.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(linkButton.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude linkButton from layout');
      Component.setIncludeInLayout(linkButton, false);
      logMessage('Include linkButton in layout');
      Component.setIncludeInLayout(linkButton, true);
    });
  });
}