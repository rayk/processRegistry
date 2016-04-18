library logger;

import 'package:processRegistry/process_lib.dart';
import 'dart:developer';

main(List args, message) {
  configureProcess(new LoggerProcess(), 'LoggerProcess',
      '1.1.5'), args, message,
      supportResourceSaving: false,
      supportResponseStreaming: true,
      supportAutoShutdownOnFailure: false,
      supportBroadcasting: false,
      supportFailureRecovery: true,
      supportLogging: true,
      supportMonitoring: true,
      supportMultipleRequesterChannel: true,
      supportReplyPortsInMessage: true,
      supportRequestStreaming: true,
      supportStartupConfig: true,
      supportSubProcess: false,
      supportLazyLoad: true);
}

class LoggerProcess extends Object with ProcessMixin {
  LoggerProcess() {}

  startProcess(Map startup) {
    incomingRequest.listen((Map request) {
      log(request.toString());
    });
  }
}
