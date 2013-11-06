import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'src/monomer_tests_group.dart' as monomerTests;

main() {
  groupSep = ' - ';
  useHtmlEnhancedConfiguration();

  monomerTests.main();
}
