import 'package:test/test.dart';

import 'package:processRegistry/registry_lib.dart';

///Integration test from the perspective of the user of library. Processes
///are implemented outside this package so they are passed in the registry.

main() {
  group("Get the registry for the current Isolate scope:", () {
    test("Should pass in a list of processes and return a registry.", () {});

    test("Should accept a specified logging service.",(){});

    test("Should add process to the registry.", () {});

    test("Should add another process already in the registry.", () {});

    test('Should not add process if the process is marked as unquie.', () {});

    test('Should provide information as to process status.',(){});
  });

  group("Process provisioning:", () {
    test("Should provision process with optional startup configuration.",(){});

    test("Should be able to confirm service is provisioned via registry.",(){});

    test("Should provision process that provides a single async response.",(){});

    test('Should provision process that can create subprocesses.',(){});

    test("Should provision process that provides a stream of responses.",(){});

    test("Should connect logging service to process capable of logging.",(){});
  });

  group("Shutdown and termination:",(){

    test("Should be be able to terminate a process immediately.",(){});

    test("Should terminate a process after completion of current request.",(){

    });

    test("Should be able to shutdown the registry immediately.",(){});

    test("Should shutdown the registry after completing all current request.",(){});
  });

}
