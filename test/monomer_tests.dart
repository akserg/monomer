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
