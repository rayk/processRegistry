library serviceTest;

import 'package:test/test.dart';
import 'package:processRegistry/process_lib.dart';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'dart:isolate';

main() {
  ReceivePort testRecPortA = new ReceivePort();
  ReceivePort testRecPortB = new ReceivePort();

  Map provisionA = {specRequest.Debug: false, specRequest.SendPort: testRecPortA.sendPort};
  Map provisionB = {specRequest.Debug: false, specRequest.SendPort: testRecPortB.sendPort};
  List argsA = [provisionA, 'anotherItem', 'moreItems'];
  List argsB = [provisionB, 'justMore', 'Items', 'toSee'];
  var message = "Message";

  group("Remote Process Starting:", () {

    test("Should return a process specification Map to registry.", () async {
      testRecPortA.listen(expectAsync((Map spec) {
        print(spec);
        expect(spec is Map, isTrue);
        testRecPortA.close();
      }, count: 1));
      startupFunction(argsA, message);
    });

    test("Should contain adequate data points to create registration.",() async{
      testRecPortB.listen(expectAsync((Map spec) {
        expect(spec is Map, isTrue);
        testRecPortB.close();
      }, count: 1));
      startupFunction(argsB, message);
    });
  });
}

startupFunction(List arg, message) {
  configureProcess(new MockService(), 'EchoProcess', new Version(0, 1, 0), arg, message,
      supportMonitoring: true,
      supportBroadcasting: false,
      supportLogging: true,
      supportMultipleRequesterChannel: false,
      supportRequestStreaming: true,
      supportFailureRecovery: true,
      supportResponseStreaming: true,
      supportResourceSaving: false,
      supportSubProcess: false,
      supportStartupConfig: true,
      supportAutoShutdownOnFailure: false,
      supportReplyPortsInMessage: true);
}

class MockService extends Object with ProcessMixin {
  List initialArgs;
  var initialMessage;

  MockService() {
  }

  startProcess(Map startup) =>
      incomingRequest.listen((Map request) {});
}
