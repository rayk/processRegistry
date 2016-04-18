library registry_test;

import 'dart:async';

import 'package:processRegistry/src/registry/registry.dart';
import 'package:test/test.dart';

main() {
  group('Grab Registry:', () {
    List toBeRegistered = [
      [
        "Accumulate",
        "0.0.1",
        ["example", "process_examples", "accumulate", "entry_point.dart"]
      ],
      [
        "Echo",
        '0.0.2',
        ['example', "process_examples", "echo", "entry_point.dart"]
      ],
      [
        "Echo2",
        "BadVersionNumberShouldFail",
        ['example', "process_examples", "echo", "entry_point.dart"]
      ],
      [
        "Spray",
        "0.0.1",
        ["example", "process_examples", "spray", "entry_point.dart"]
      ],
      [
        "Fail",
        "0.0.0",
        ["does", "not", "exist", "should", "go", "failed", "entry_point.dart"]
      ]
    ];

    test('Should always return same instance of registry.', () async {
      Registry rg1 = new Registry();
      expect(rg1, isNotNull);
      Registry rg3 = new Registry();
      Registry rg2 = new Registry();
      expect(rg1 == rg2, isTrue, reason: 'Not behaviouring like singleton');
      expect(rg2 == rg3, isTrue);
    });

    test('Should remain as signleton with optional list passed in.', () {
      Registry testRg =
          new Registry(processes: toBeRegistered, debugger: false);
      expect(testRg, isNotNull);
      Registry testCheck = new Registry();
      expect(testCheck == testRg, isTrue);
    });

    test('Should provide empty process audit log when no processes submitted.',
        () async {
      Registry testRg = new Registry();
      List processStates = await testRg.processAuditLog();
      expect(processStates.isEmpty, isTrue);
    });
  });
}
