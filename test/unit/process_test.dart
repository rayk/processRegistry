library serviceTest;

import 'package:test/test.dart';
import 'package:processRegistry/process_lib.dart';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'dart:isolate';

main() {

  ReceivePort testRecPort = new ReceivePort();

  List args = [testRecPort.sendPort];
  var message = "Message";


  group("Remote Process:", (){
    test("Should return a process specification.",() async {

      testRecPort.listen(expectAsync((Map spec){
        expect(spec is Map, isTrue);
        expect(spec[proConfigKeys.DefaultProcessSendPort], isTrue, reason: 'No sign to keep using port.');
        expect(spec[proConfigKeys.ExclusiveIsolate], isTrue, reason: 'No it need a fulltime execlusive.');
        expect(spec[proConfigKeys.FailOnUnCaughtExceptions], isFalse, reason: 'Set on Ioolate confriguration');
        expect(spec[proConfigKeys.Id], isNotNull, reason: 'Id required for tracking');
        expect(spec[proConfigKeys.LinkToLogService], isTrue, reason: 'Does it need a loging service');
        expect(spec[proConfigKeys.Name], equals('EchoProcess'));
        expect(spec[proConfigKeys.PortExchange], isTrue, reason: 'Does it need a port exchange done');
        expect(spec[proConfigKeys.RecoverFailedProcess], isTrue, reason: 'Listen for exists and restart?');
        expect(spec[proConfigKeys.SetOnErrorPort], isTrue, reason: 'Monitor for errors');
        expect(spec[proConfigKeys.SetPerConsumerReceivePorts], isFalse, reason: "Aggragated will be fine");
        expect(spec[proConfigKeys.Version], equals("0.1.0"), reason: "The version of the process it thinks");
      }, count: 1));

      startupFunction(args, message);

    });
  });

}

startupFunction(List arg, message){

  configureProcess(
      new TestService(arg, message), 'EchoProcess', new Version(0, 1, 0),
      canProcessBeMonitored: true,
      canProcessBroadcastResponses: false,
      canProcessConnectToLogging: true,
      canProcessPartitionRequest: false,
      canProcessReceiveOnGoingRequest: true,
      canProcessRecoverAfterFailure: true,
      canProcessResponseToRequest: true,
      canProcessShareIsolate: false,
      canProcessSpawn: false,
      canProcessTakeInitialArgs: true,
      canProcessTerminatesOnFailure: false,
      canProcessUseReplyToPorts: true);

}

class TestService extends Object with ProcessMixin {
  List initialArgs;
  var initialMessage;

  TestService(args, message) {
    initialArgs = args;
    initialMessage = message;
  }

  startProcess(ReceivePort incomingRequest, List startupArgs) {
    incomingRequest.listen((Map request) {});
  }
}
