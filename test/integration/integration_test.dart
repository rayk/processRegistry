import 'package:test/test.dart';

import 'package:processRegistry/registry_lib.dart';

///Integration test from the perspective of the user of library. Processes
///are implemented outside this package so they are passed in the registry.

main() {
  group("Get a registry for the current Isolate scope:", () {
    test("Should pass in a list of processes and return a registry.", () {});

    test("Should add process to an existing registry.", () {});

    test("Should add another process already in the registry.", () {});

    test('Should not add process if the process is marked as unquie. ', () {});

    test('Should remove a process from the registry.', () {});
  });

  group("Provision process that does not retunn a value:", () {});

  group("Provision process that provides a single return:",(){});

  group("Provision process that provides a stream of responses:",(){});

  group("Provision process that provisions it's own process",(){});

}
