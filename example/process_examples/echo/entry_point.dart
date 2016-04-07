library echoProcess;

import 'package:processRegistry/process_lib.dart';
import 'dart:isolate';

main(List args, message) {
  assert(args[0] is SendPort);

  configureProcess(
      new EchoProcess(args, message), 'EchoProcess', new Version(0, 1, 0),
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

class EchoProcess extends Object with ProcessMixin {
  List initialArgs;
  var initialMessage;

  EchoProcess(args, message) {
    initialArgs = args;
    initialMessage = message;
  }

  startProcess(ReceivePort incomingRequest, List startupArgs){
    incomingRequest.listen((Map request){

    });
  }

}
