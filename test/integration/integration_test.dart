import 'package:test/test.dart';

import 'package:processRegistry/registry_lib.dart';

///Integration test from the perspective of the user of library. Processes
///are implemented outside this package so they are passed in the registry.

main() {
  group("Get the registry for the current Isolate scope:", () {
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
    test("Should pass in a list of processes and return a registry.", () {
      Registry testRegistry =
          new Registry(processes: processList, debugger: true);
      expect(testRegistry.requestedRegistration.length, equals(processList.length));
    });

    test("Should accept a specified logging service.", () {
      throw new NotImplementedException('Loging service');
    });

    test("Should add process to the registry.", () {});

    test("Should add another process already in the registry.", () {});

    test('Should not add process if the process is marked as unquie.', () {});

    test('Should provide information as to process status.', () {});
  });

  group("Process provisioning:", () {
    test(
        "Should provision process with optional startup configuration.", () {});

    test("Should be able to confirm service is provisioned via registry.",
        () {});

    test("Should provision process that provides a single async response.",
        () {});

    test('Should provision process that can create subprocesses.', () {});

    test(
        "Should provision process that provides a stream of responses.", () {});

    test(
        "Should connect logging service to process capable of logging.", () {});
  });

  group("Shutdown and termination:", () {
    test("Should be be able to terminate a process immediately.", () {});

    test("Should terminate a process after completion of current request.",
        () {});

    test("Should be able to shutdown the registry immediately.", () {});

    test("Should shutdown the registry after completing all current request.",
        () {});
  });
}
