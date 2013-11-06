//Copyright (C) 2012 Sergey Akopkokhyants. All Rights Reserved.
//Author: akserg

library monomer_test;

import 'dart:html';
import 'package:unittest/unittest.dart';

part 'test_group.dart';

void main() {

  final _tList = new List<TestGroup>();

//  _tList.add(new UiObjectTestGroup());

  _tList.forEach((TestGroup t){
    group(t.testGroupName, (){
      t.testList.forEach((String name, Function testFunc){
        test(name, testFunc);
      });
    });
  });

}
