library monomer_tests;

//import 'dart:async';
//import 'dart:html';
import 'package:unittest/unittest.dart';
//import 'package:widget/effects.dart';

part 'button_tests.dart';

void main() {
  group('Monomer', () {
    registerButtonTests();
  });
}
/*
void setupTestTimeManager() {
  AnimationQueue.timeManagerFactory = () {
    assert(_timeManagerInstance == null);
    return _timeManagerInstance = new TestTimeManager();
  };
}

void tearDownTestTimeManager() {
  AnimationQueue.disposeInstance();
  if(_timeManagerInstance != null) {
    assert(_timeManagerInstance.isDisposed);
    _timeManagerInstance = null;
  }
}

TestTimeManager _timeManagerInstance;

void _createPlayground() {
  final existing = _getPlayground();
  assert(existing == null);
  // assert no playground exists
  final pg = new DivElement();
  pg.classes.add('playground');
  document.body.append(pg);
  // insert it
}

void _cleanUpPlayground() {
  final existing = _getPlayground();
  assert(existing != null);
  existing.remove();
}

DivElement _getPlayground() => query('div.playground');
*/