// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void formTests() {
  logMessage('Performing Form tests.');

  group('Testing Form:', () {
    Form form;
    var dataToSend = {'id':1, 'name':'Test Name'};
    
    setUp((){
      form = new Form();
      document.body.append(form);
    });
    
    tearDown((){
      form.remove();
    });
    
    test('Do Action', () {
      logMessage('Expect call action method when user submit form');
      
      form.data = dataToSend;
      
      form.onAction.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('action'), reason:'must be action event type');
      });
      
      logMessage('Click on form');
      form.dispatchEvent(new CustomEvent(Component.ACTION_EVENT));
    });
    
    test('Do Visible', () {
      logMessage('Expect make form visible or invisible');
      
      form.onVisible.listen((event) {
        logMessage('Handle Visible Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        // Check the state
        bool visible = (event as CustomEvent).detail;
        if (visible) {
          expect(form.style.display, equals(''), reason:'must be visible');
        } else {
          expect(form.style.display, equals('none'), reason:'must be invisible');
        }
      });
      
      logMessage('Set form invisible');
      Component.setVisible(form, false);
      logMessage('Set form visible');
      Component.setVisible(form, true);
    });
    
    test('Do Include in Layout', () {
      logMessage('Expect include or exclude form from layout');
      
      form.onIncludeInLayout.listen((event) {
        logMessage('Handle IncludeInLayout Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        // Check the state
        bool visibility = (event as CustomEvent).detail;
        if (visibility) {
          expect(form.style.visibility, equals('visible'), reason:'must be include in layout');
        } else {
          expect(form.style.visibility, equals('hidden'), reason:'must be exnclude from layout');
        }
      });
      
      logMessage('Exclude form from layout');
      Component.setIncludeInLayout(form, false);
      logMessage('Include form in layout');
      Component.setIncludeInLayout(form, true);
    });
    
    test('Do POST Action', () {
      logMessage('Expect call POST action method when user submit form');

      AjaxMock ajax = new AjaxMock();
      ajax.data = dataToSend;
      
      form.data = dataToSend;
      form.url = "dummy";
      form.ajax = ajax;
      
      form.onAction.listen((event) {
        logMessage('Handle Action Event');
        expect(event, new isInstanceOf<CustomEvent>(), reason:'must be CustomEvent');
        expect(event.type, equals('action'), reason:'must be action event type');
        expect(event.detail, equals(dataToSend), reason:'must return sent data');
      });
      
      logMessage('Click on form');
      form.dispatchEvent(new MouseEvent('click'));
    });
  });
}