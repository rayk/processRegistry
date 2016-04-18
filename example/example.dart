import 'dart:developer';

import 'package:processRegistry/registry_lib.dart';

/// Debugging runtime example.

main() {
  List<List<String>> processList = [
    [
      'EchoProcess',
      '2.3.2',
      ['example', 'process_examples', 'echo', 'entry_point.dart']
    ],
    [
      'AccumulateProcess',
      '1.1.0',
      ['example', 'process_examples', 'accumulate', 'entry_point.dart']
    ],
    [
      'SleeperProcess',
      '1.3.2',
      ['example', 'process_examples', 'slepper', 'entry_point.dart']
    ],
    [
      'SprayProcess',
      '1.2.2',
      ['example', 'process_examples', 'spray', 'entry_point.dart'],
    ]
  ];

  Registry testRegistry = new Registry(processes: processList, debugger: true);

  List<Registration> regos = testRegistry.registrations;
  List requested = testRegistry.requestedRegistration;

  print(requested);
}
