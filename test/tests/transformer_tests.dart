// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

part of monomer_tests;

void transformerTests() {
  logMessage('Performing button tests.');

  group('Testing button:', () {
    Transformer toInt = new ToInt();
    Transformer toDouble = new ToDouble();
    Transformer toBool = new ToBool();
    Transformer toUpperCase = new ToUpperCase();
    Transformer toLowerCase = new ToLowerCase();
    
    test('Do ToInt', () {
      logMessage('Expect transform String to Int and back');
      
      logMessage('Forward tranformation');
      expect(toInt.forward(null), "", reason:'must be empty');
      expect(toInt.forward(1), "1", reason:'must be 1');
      
      logMessage('Reverse tranformation');
      expect(toInt.reverse(null), isNull, reason:'must be null');
      expect(toInt.reverse("abc"), isNull, reason:'must be null');
      expect(toInt.reverse("1.1"), isNull, reason:'must be null');
      expect(toInt.reverse("1"), 1, reason:'must be 1');
    });
    
    test('Do ToDouble', () {
      logMessage('Expect transform String to Double and back');
      
      logMessage('Forward tranformation');
      expect(toDouble.forward(null), "", reason:'must be empty');
      
      logMessage('Reverse tranformation');
      expect(toDouble.reverse(null), isNull, reason:'must be null');
      expect(toDouble.reverse("abc"), isNull, reason:'must be null');
      expect(toDouble.reverse("1.1"), 1.1, reason:'must be 1.1');
      expect(toDouble.reverse("1"), 1, reason:'must be 1');
    });
    
    test('Do ToBool', () {
      logMessage('Expect transform String to Bool and back');
      
      logMessage('Forward tranformation');
      expect(toBool.forward(null), "", reason:'must be empty');
      expect(toBool.forward(true), "true", reason:'must be true');
      expect(toBool.forward(false), "false", reason:'must be false');
      
      logMessage('Reverse tranformation');
      expect(toBool.reverse(null), isNull, reason:'must be null');
      expect(toBool.reverse("abc"), false, reason:'must be false');
      expect(toBool.reverse("1.1"), false, reason:'must be false');
      expect(toBool.reverse("1"), false, reason:'must be false');
      expect(toBool.reverse("false"), false, reason:'must be false');
      expect(toBool.reverse("true"), true, reason:'must be true');
    });
    
    test('Do ToUpperCase', () {
      logMessage('Expect transform String to Uppercase and back');
      
      logMessage('Forward tranformation');
      expect(toUpperCase.forward(null), "", reason:'must be empty');
      expect(toUpperCase.forward("abc"), "ABC", reason:'must be ABC');
      expect(toUpperCase.forward("ABC"), "ABC", reason:'must be ABC');
      expect(toUpperCase.forward("AbC"), "ABC", reason:'must be ABC');
      
      logMessage('Reverse tranformation');
      expect(toUpperCase.reverse(null), isNull, reason:'must be null');
      expect(toUpperCase.reverse("abc"), 'abc', reason:'must be the same');
      expect(toUpperCase.reverse("ABC"), 'ABC', reason:'must be the same');
    });
    
    test('Do ToLowerCase', () {
      logMessage('Expect transform String to Lower and back');
      
      logMessage('Forward tranformation');
      expect(toLowerCase.forward(null), "", reason:'must be empty');
      expect(toLowerCase.forward("abc"), "abc", reason:'must be abc');
      expect(toLowerCase.forward("ABC"), "abc", reason:'must be abc');
      expect(toLowerCase.forward("AbC"), "abc", reason:'must be abc');
      
      logMessage('Reverse tranformation');
      expect(toLowerCase.reverse(null), isNull, reason:'must be null');
      expect(toLowerCase.reverse("abc"), 'abc', reason:'must be the same');
      expect(toLowerCase.reverse("ABC"), 'ABC', reason:'must be the same');
    });
  });
}