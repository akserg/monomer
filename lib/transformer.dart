// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library monomer_transformer;

import 'package:polymer_expressions/filter.dart';

/**
 * Transform String to Integer
 */
class ToInt extends Transformer<String, int> {
  String forward(int input) => input == null ? '' : input.toString();
  int reverse(String input) => input == null ? null : int.parse(input, onError:(String e) => null);
}

/**
 * Transform String to Double
 */
class ToDouble extends Transformer<String, double> {
  String forward(double input) => input == null ? '' : input.toString();
  double reverse(String input) => input == null ? null : double.parse(input, (String e) => null);
}

/**
 * Transform String to Bool
 */
class ToBool extends Transformer<String, bool> {
  String forward(bool input) => input == null ? '' : input.toString();
  bool reverse(String input) => input == null ? null : input == 'true' ? true : false;
}

/**
 * Transform String to UpperCase
 */
class ToUpperCase extends Transformer<String, String> {
  String forward(String input) => input == null ? '' : input.toUpperCase();
  String reverse(String input) => input;
}

/**
 * Transform String to LowerCase
 */
class ToLowerCase extends Transformer<String, String> {
  String forward(String input) => input == null ? '' : input.toLowerCase();
  String reverse(String input) => input;
}