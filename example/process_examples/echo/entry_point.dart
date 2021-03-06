library echoProcess;

import 'package:processRegistry/process_lib.dart';


main(List args, message) {

  /// Standard process configuration function every process needs to implement.
  configureProcess(
      new EchoProcess(), 'EchoProcess', "0.0.1", args, message,
      supportResourceSaving: false,
      supportResponseStreaming: true,
      supportAutoShutdownOnFailure: false,
      supportBroadcasting: false,
      supportFailureRecovery: true,
      supportLogging: true,
      supportMonitoring: true,
      supportReplyPortsInMessage:  true,
      supportRequestStreaming: true,
      supportStartupConfig: true,
      supportSubProcess:  false,
      supportLazyLoad: true);
}

/// The namespace which encapsulates the process.
class EchoProcess extends Object with ProcessMixin {

  EchoProcess() {}

  processRequest(){

  }





}

