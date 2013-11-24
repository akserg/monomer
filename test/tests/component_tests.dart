// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void componentTests() {
  logMessage('Performing Component tests.');

  group('Testing Component:', () {
    InputElement button;
    
    setUp((){
      button = new InputElement();
      button.type = 'button';
      document.body.append(button);
    });
    
    tearDown((){
      button.remove();
    });
    
    test('Do SetVisible', () {
      logMessage('Expect set element visible');

      logMessage('Set element invisible');
      Component.setVisible(button, false);
      expect(button.style.display, equals('none'), reason:'must be none');
      expect(button.attributes['aria-hidden'], equals('true'), reason:'must be true');
      expect(Component.isVisible(button), equals(false), reason:'must be false');
      //
      logMessage('Set element visible');
      Component.setVisible(button, true);
      expect(button.style.display, equals(''), reason:'must be empty');
      expect(button.attributes['aria-hidden'], equals('false'), reason:'must be false');
      expect(Component.isVisible(button), equals(true), reason:'must be true');
    });
    
    test('Do setIncludeInLayout', () {
      logMessage('Expect set element visibility');

      logMessage('Remove element from layout');
      Component.setIncludeInLayout(button, false);
      expect(button.style.visibility, equals('hidden'), reason:'must be hidden');
      expect(Component.isIncludeInLayout(button), equals(false), reason:'must be false');
      //
      logMessage('Add element to layout');
      Component.setIncludeInLayout(button, true);
      expect(button.style.visibility, equals('visible'), reason:'must be visible');
      expect(Component.isIncludeInLayout(button), equals(true), reason:'must be true');
    });
    
    test('Do setEnabled', () {
      logMessage('Expect set element enabled');

      logMessage('Set element disabled');
      Component.setEnabled(button, false);
      expect(button.disabled, equals(true), reason:'must be true');
      expect(button.attributes['aria-disabled'], equals('true'), reason:'must be true');
      expect(Component.isEnabled(button), equals(false), reason:'must be false');
      //
      logMessage('Set element enabled');
      Component.setEnabled(button, true);
      expect(button.disabled, equals(false), reason:'must be false');
      expect(button.attributes['aria-disabled'], equals('false'), reason:'must be false');
      expect(Component.isEnabled(button), equals(true), reason:'must be true');
    });
    
    test('Do addClasses and removeClasses', () {
      logMessage('Expect add classes to element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Add class to element');
      Component.addClasses(button, 'my-element');
      expect(button.classes.contains('my-element'), equals(true), reason:'must be true');
      //
      logMessage('Remove class from element');
      Component.removeClasses(button, 'my-element');
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
    });
    
    test('Do addClasses and removeClasses with prefix', () {
      logMessage('Expect add classes with prefix to element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Add class to element');
      Component.addClasses(button, 'my-element', 'new-');
      expect(button.classes.contains('new-my-element'), equals(true), reason:'must be true');
      //
      logMessage('Remove class from element');
      Component.removeClasses(button, 'my-element', 'new-');
      expect(button.classes.contains('new-my-element'), equals(false), reason:'must be false');
    });
    
    test('Do swapClasses', () {
      logMessage('Expect swap classes in element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Add class to element');
      Component.addClasses(button, 'my-element');
      expect(button.classes.contains('my-element'), equals(true), reason:'must be true');
      //
      logMessage('Swap class in element');
      Component.swapClasses(button, 'my-element', 'new-element');
      expect(button.classes.contains('new-element'), equals(true), reason:'must be true');
    });
    
    test('Do swapClasses with prefix', () {
      logMessage('Expect swap classes with prefix in element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Add class to element');
      Component.addClasses(button, 'my-element', 'new-');
      expect(button.classes.contains('new-my-element'), equals(true), reason:'must be true');
      //
      logMessage('Swap class in element');
      Component.swapClasses(button, 'my-element', 'new-element', 'new-');
      expect(button.classes.contains('new-new-element'), equals(true), reason:'must be true');
    });
    
    test('Do toggleClasses', () {
      logMessage('Expect toggle classes in element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Toggle class in element');
      Component.toggleClasses(button, true, 'my-element');
      expect(button.classes.contains('my-element'), equals(true), reason:'must be true');
      //
      logMessage('Toggle class in element');
      Component.toggleClasses(button, false, 'my-element');
      expect(button.classes.contains('new-element'), equals(false), reason:'must be false');
    });
    
    test('Do toggleClasseswith prefix', () {
      logMessage('Expect toggle classes with prefix in element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Toggle class in element');
      Component.toggleClasses(button, true, 'my-element', 'new-');
      expect(button.classes.contains('new-my-element'), equals(true), reason:'must be true');
      //
      logMessage('Toggle class in element');
      Component.toggleClasses(button, false, 'my-element', 'new-');
      expect(button.classes.contains('new-new-element'), equals(false), reason:'must be false');
    });
    
    test('Do clearClasses', () {
      logMessage('Expect clear classes to element');
     
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
      //
      logMessage('Add class to element');
      Component.addClasses(button, 'my-element');
      expect(button.classes.contains('my-element'), equals(true), reason:'must be true');
      //
      logMessage('Clear class from element');
      Component.clearClasses(button);
      expect(button.classes.contains('my-element'), equals(false), reason:'must be false');
    });
  });
}
