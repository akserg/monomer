// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_tests;

/**
 * Unit testing for Monomer library.
 */

import 'package:polymer/polymer.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:monomer/button.dart';
import 'package:monomer/post_button.dart';
import 'dart:html';

part 'tests/button_tests.dart';

void main() {
  print('Running unit tests for Monomer library.');
  initPolymer();
  useHtmlEnhancedConfiguration();
  group('All Tests:', (){
  	test('button', () => buttonTests());
  	test('POST button', () => postButtonTests());
  });
}
