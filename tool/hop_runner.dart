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

library dumprendertree;

/**
 * Headless testing with Hop.
 */

import 'package:hop/hop.dart';
import 'dart:io';
import 'dart:async';

main(List<String> args) {
  addTask('test', createUnitTestTask());
  runHop(args);
}

Task createUnitTestTask() {
  return new Task((TaskContext tcontext) {
    tcontext.info("Running Unit Tests....");
    var result = Process.run('content_shell',
        ['--dump-render-tree','test/monomer_tests.html'])
        .then((ProcessResult process) {
          tcontext.info(process.stdout);
        });
    return result;
  });
}