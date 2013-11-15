// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_tests;

/**
 * Unit testing for Monomer library.
 */

import 'dart:html';
import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'package:monomer/component.dart';
import 'package:monomer/button.dart';
import 'package:monomer/post_button.dart';
import 'package:monomer/delete_button.dart';
import 'package:monomer/upload_button.dart';
import 'package:monomer/validator.dart';
import 'package:monomer/string_validator.dart';
import 'package:monomer/number_validator.dart';
import 'package:monomer/regexp_validator.dart';

part 'tests/button_tests.dart';
part 'tests/post_button_tests.dart';
part 'tests/delete_button_tests.dart';
part 'tests/upload_button_tests.dart';
part 'tests/validator_tests.dart';
part 'tests/string_validator_tests.dart';
part 'tests/number_validator_tests.dart';
part 'tests/regexp_validator_tests.dart';

void main() {
  print('Running unit tests for Monomer library.');
  initPolymer();
  useHtmlEnhancedConfiguration();
  group('All Tests:', (){
  	test('button', () => buttonTests());
  	test('POST button', () => postButtonTests());
  	test('Delete button', () => deleteButtonTests());
  	test('Upload button', () => uploadButtonTests());
  	
  	test('Validator', () => validatorTests());
  	test('String Validator', () => stringValidatorTests());
  	test('Number Validator', () => numberValidatorTests());
  	test('RegExp Validator', () => regexpValidatorTests());
  });
}
