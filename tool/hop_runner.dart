import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

import '../test/harness_console.dart' as test;

void main(args) {
  addTask('build', createProcessTask('dart', args: ['build.dart'],
  	description: "execute the project's build.dart file"));

  List<String> paths = ['out/index.html.dart'];
  addTask('dart2js', createDartCompilerTask(paths, 
  	verbose:true, outputType:CompilerTargetType.JS));

  addTask('test_dart2js',
      createDartCompilerTask(['test/browser_test_harness.dart'],
      verbose:true));

  addTask('test', createUnitTestTask(test.testCore));

  //
  // gh_pages
  //
  addAsyncTask('pages', (ctx) =>
      branchForDir(ctx, 'master', 'example', 'gh-pages'));

  //
  // populate components into example dir
  //
  addAsyncTask('copy_components', (ctx) =>
      startProcess(ctx, './bin/copy_out.sh'));

  runHop(args);
}
