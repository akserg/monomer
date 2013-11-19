// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void listUtilityTests() {
  logMessage('Performing Utility tests.');

  group('Testing Utility:', () {
    List list;
    
    setUp((){
      list = [];
      list.add(new _Order(1, "One", new _User("Me")));
      list.add(new _Order(2, "Two", new _User("You")));
      list.add(new _Order(3, "Three", new _User("Other")));
    });
    
    tearDown((){
      list = null;
    });
    
    
    test('Check getValue', () {
      logMessage('Expect return value from getValue');
      
      _Order order = new _Order(1, "One", new _User("Me"));
      String valuePath = "user.username";
      String username = Utility.getValue(order, valuePath);
      
      logMessage('Check result of Utility.getValue');
      expect(username, equals("Me"), reason:'must be equals Me');
    });
    
    test('Check setValue', () {
      logMessage('Expect set value in setValue');
      
      _Order order = new _Order(1, "One", new _User("Me"));
      String valuePath = "user.username";
      Utility.setValue(order, valuePath, "You");
      String username = Utility.getValue(order, valuePath);
      
      logMessage('Check result of Utility.getValue');
      expect(username, equals("You"), reason:'must be equals You');
    });
    
    test('Check getValues', () {
      logMessage('Expect return values from getValues');
      
      String valuePath = "user.username";
      List result = Utility.getValues(list, valuePath);
      
      logMessage('Check result of Utility.getValues');
      expect(result.length, equals(3), reason:'must be equals 3');
      expect(result.first, equals("Me"), reason:'must be equals Me');
      expect(result.last, equals("Other"), reason:'must be equals Other');
    });
    
    test('Check getMatch', () {
      logMessage('Expect return values from getMatch');
      
      String valuePath = "name";
      _Order result = Utility.getMatch(list, valuePath, "Two");
      
      logMessage('Check result of Utility.getMatch');
      expect(result, isNotNull, reason:'must not be null');
      expect(result.name, equals("Two"), reason:'must be equals Two');
    });
    
    test('Check intersect', () {
      logMessage('Expect return values from intersect');
      
      List values = [];
      values.add(new _Order(4, "Four"));
      values.add(new _Order(2, "One"));
      values.add(new _Order(3, "Three"));
      values.add(new _Order(5, "Five"));
      
      String valuePath = "name";
      List<_Order> result = Utility.intersect(list, valuePath, values);
      
      logMessage('Check result of Utility.intersect');
      expect(result.length, equals(2), reason:'must be equals 2');
      expect(result.first.name, equals("One"), reason:'must be equals One');
      expect(result.last.name, equals("Three"), reason:'must be equals Three');
    });
  });
}

class _Order {
  int id;
  String name;
  _User user;
  
  _Order(this.id, this.name, [this.user = null]);
}

class _User {
  String username;
  
  _User(this.username);
}