library echoProcess;

import 'package:processRegistry/process_lib.dart';


main(List args, message) {

  /// Standard process configuration function every process needs to implement.
  configureProcess(
      new EchoProcess(), 'EchoProcess', new Version(0, 1, 0), args, message,
      supportResourceSaving: false,
      supportResponseStreaming: true,
      supportsAutoShutdownOnFailures: false,
      supportsBroadcasting: false,
      supportsFailureRecovery: true,
      supportsLogging: true,
      supportsMonitoring: true,
      supportsMultiRequesterChannel: false,
      supportsReplyPortsInMessages: true,
      supportsRequestStreaming: true,
      supportsStartupConfig: true,
      supportsSubProcesses: false);
}

/// The namespace which encapsulates the process.
class EchoProcess extends Object with ProcessMixin {

  EchoProcess() {}

  /// Called after the configuration has been applied, once call all incoming
  /// request need to be handled by the process.
  startProcess(Map startup){
    incomingRequest.listen((Map request){

    });
  }


}

