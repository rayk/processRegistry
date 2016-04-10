library serviceTest;

import 'package:test/test.dart';
import 'package:processRegistry/process_lib.dart';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'dart:isolate';

main() {
  ReceivePort testRecPort = new ReceivePort();

  Map provision = {regProvisionValues.Debug: false, regProvisionValues.SendPort: testRecPort.sendPort};
  List args = [provision, 'anotherItem', 'moreItems'];
  var message = "Message";

  group("Remote Process:", () {

    test("Should return a process specification to registry.", () async {
      testRecPort.listen(expectAsync((Map spec) {
        expect(spec is Map, isTrue);
        expect(spec[configKey.DefaultProcessSendPort], isTrue,
            reason: 'No sign to keep using port.');
        expect(spec[configKey.CollectibleIsolate], isTrue,
            reason: 'No it need a fulltime execlusive.');
        expect(spec[configKey.FailOnUnCaughtExceptions], isFalse,
            reason: 'Set on Ioolate confriguration');
        expect(spec[configKey.UniqueIdentifier], isNotNull,
            reason: 'Id required for tracking');
        expect(spec[configKey.LinkToLogService], isTrue,
            reason: 'Does it need a loging service');
        expect(spec[configKey.Name], equals('EchoProcess'));
        expect(spec[configKey.PortExchange], isTrue,
            reason: 'Does it need a port exchange done');
        expect(spec[configKey.RestartOnFail], isTrue,
            reason: 'Listen for exists and restart?');
        expect(spec[configKey.SetIsolateListeners], isTrue,
            reason: 'Monitor for errors');
        expect(spec[configKey.SetPerConsumerReceivePorts], isFalse,
            reason: "Aggragated will be fine");
        expect(spec[configKey.Version], equals("0.1.0"),
            reason: "The version of the process it thinks");
      }, count: 1));

      startupFunction(args, message);
    });
  });
}

startupFunction(List arg, message) {
  configureProcess(new MockService(), 'EchoProcess', new Version(0, 1, 0), arg, message,
      supportsMonitoring: true,
      supportsBroadcasting: false,
      supportsLogging: true,
      supportsMultiRequesterChannel: false,
      supportsRequestStreaming: true,
      supportsFailureRecovery: true,
      supportResponseStreaming: true,
      supportResourceSaving: false,
      supportsSubProcesses: false,
      supportsStartupConfig: true,
      supportsAutoShutdownOnFailures: false,
      supportsReplyPortsInMessages: true);
}

class MockService extends Object with ProcessMixin {
  List initialArgs;
  var initialMessage;

  MockService() {
  }

  startProcess(Map startup) =>
      incomingRequest.listen((Map request) {});
}
