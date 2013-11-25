// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_tests;

/**
 * Unit testing for Monomer library.
 */

import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:polymer/polymer.dart';
import 'package:polymer_expressions/filter.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
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
import 'package:monomer/comparator_validator.dart';
import 'package:monomer/ajax.dart';
import 'package:monomer/utility.dart';
import 'package:monomer/transformer.dart';
import 'package:monomer/form.dart';
import 'package:monomer/form_field.dart';
import 'package:monomer/label.dart';
import 'package:monomer/checkbox.dart';
import 'package:monomer/list_base.dart';
import 'package:monomer/checkbox_group.dart';

part 'mocks/ajax_mock.dart';

part 'tests/component_tests.dart';
part 'tests/button_tests.dart';
part 'tests/post_button_tests.dart';
part 'tests/delete_button_tests.dart';
part 'tests/upload_button_tests.dart';
part 'tests/validator_tests.dart';
part 'tests/string_validator_tests.dart';
part 'tests/number_validator_tests.dart';
part 'tests/regexp_validator_tests.dart';
part 'tests/comparator_validator_tests.dart';
part 'tests/utility_tests.dart';
part 'tests/transformer_tests.dart';
part 'tests/form_tests.dart';
part 'tests/form_field_tests.dart';
part 'tests/label_tests.dart';
part 'tests/list_base_tests.dart';
part 'tests/checkbox_tests.dart';
part 'tests/checkbox_group_tests.dart';

void main() {
  print('Running unit tests for Monomer library.');
  initPolymer();
  useHtmlEnhancedConfiguration();
  group('All Tests:', (){
    test('Component', () => componentTests());
    
  	test('Button', () => buttonTests());
  	test('POST button', () => postButtonTests());
  	test('Delete button', () => deleteButtonTests());
  	test('Upload button', () => uploadButtonTests());
  	
  	test('Validator', () => validatorTests());
  	test('String Validator', () => stringValidatorTests());
  	test('Number Validator', () => numberValidatorTests());
  	test('RegExp Validator', () => regexpValidatorTests());
  	test('RegExp Validator', () => comparatorValidatorTests());
  	
  	test('Utility', () => utilityTests());
  	
  	test('Transformer', () => transformerTests());
  	test('Form', () => formTests());
  	test('FormField', () => formFieldTests());
  	test('Label', () => labelTests());
  	test('ListBase', () => listBaseTests());
  	test('Checkbox', () => checkboxTests());
//  	test('CheckboxGroup', () => checkboxGroupTests());
  });
}
