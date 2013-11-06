library test_dump_render_tree;

import 'package:bot_test/dump_render_tree.dart';

void main() {
  final browserTests = const ['test/browser_test_harness.html'];

  testDumpRenderTree(browserTests);
}
