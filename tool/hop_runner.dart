// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library dumprendertree;

/**
 * Headless testing with Hop.
 */

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'dart:io';
import 'dart:async';

main(List<String> args) {
  addTask('test', createUnitTestTask());

  final paths = ['web/out/index.html_bootstrap.dart'];
  addTask('dart2js', createDartCompilerTask(paths,
      minify: true, liveTypeAnalysis: true));

  addTask('dart2js', createDartCompilerTask(['web/game_web.dart'],
      minify: true, liveTypeAnalysis: true));

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