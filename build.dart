// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

import 'package:polymer/builder.dart';

main(args) {
	build(entryPoints: ['web/index.html'], 
	      options: parseOptions(args));
}