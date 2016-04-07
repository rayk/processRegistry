library process;

import 'dart:isolate';
import 'package:pub_semver/pub_semver.dart';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'package:uuid/uuid.dart';

export 'package:pub_semver/pub_semver.dart' show Version;

/// Used as base of processes.
abstract class ProcessMixin {
  final ReceivePort _primaryReceivePort = new ReceivePort();
  Map _processConfiguration;
  List<ReceivePort> _requesterRequest;
  List<SendPort> _requesterResponse;

  List get initialArgs => initialArgs;

  startProcess(ReceivePort incomingRequest, List startupArgs);
}

/// Passes the specification of the service back to the registry.
_publishSpecification(ProcessMixin process, Map _registryConfig) {
  SendPort tempProvisionPort = process.initialArgs[0];
  tempProvisionPort.send(_registryConfig);
}

/// Creates a specification mapping describing how the process should be
/// configured in term of ports and low level behaviour.
configureProcess(ProcessMixin process, String processName, Version version,
    {bool canProcessBroadcastResponses: false, // Process responses by broadcast.
    bool canProcessBeMonitored: true, //
    bool canProcessConnectToLogging: true, // Can send logging to a passed in sendPort.
    bool canProcessPartitionRequest: false, // Uses a
    bool canProcessReceiveOnGoingRequest: true, // Listens to the receive port.
    bool canProcessRecoverAfterFailure: true, // Try to restart after exit.
    bool canProcessResponseToRequest: true, // Will reply if you give it a send port.
    bool canProcessShareIsolate: false,
    bool canProcessSpawn: false, // Can have it's own sub-processes.
    bool canProcessHaveMultipleInstance: false, // Can run multi instances of service.
    bool canProcessTakeInitialArgs: false, // Can be configurated
    bool canProcessTerminatesOnFailure: true,
    bool canProcessUseReplyToPorts: true}) {
  var uuid = new Uuid();


  Map processConfig = {
    proConfigKeys.CreateBroadCastStream: canProcessBroadcastResponses,
    proConfigKeys.DefaultProcessSendPort: canProcessResponseToRequest,
    proConfigKeys.ExtractProcessArgs: canProcessTakeInitialArgs,
    proConfigKeys.LinkToLogService: canProcessConnectToLogging,
    proConfigKeys.ReplyOnRequestSendPort: canProcessUseReplyToPorts,
    proConfigKeys.RequiresRegister: canProcessSpawn,
    proConfigKeys.SetPerConsumerReceivePorts: canProcessPartitionRequest,
    proConfigKeys.UniqueIdentifier: canProcessShareIsolate
        ? uuid.v4().toString().substring(0, 7)
        : Isolate.current.hashCode,
  };

  Map registryConfig = {
    proConfigKeys.DefaultProcessSendPort: canProcessResponseToRequest,
    proConfigKeys.ExclusiveIsolate: !canProcessShareIsolate,
    proConfigKeys.FailOnUnCaughtExceptions: canProcessTerminatesOnFailure,
    proConfigKeys.Id: processConfig[proConfigKeys.UniqueIdentifier],
    proConfigKeys.LinkToLogService: canProcessConnectToLogging,
    proConfigKeys.Name: processName,
    proConfigKeys.MultiInstances: canProcessHaveMultipleInstance,
    proConfigKeys.PortExchange: canProcessReceiveOnGoingRequest,
    proConfigKeys.RecoverFailedProcess: canProcessRecoverAfterFailure,
    proConfigKeys.SetOnErrorPort: canProcessBeMonitored,
    proConfigKeys.SetPerConsumerReceivePorts: canProcessPartitionRequest,
    proConfigKeys.Version: version.toString(),
  };

  _publishSpecification(process, registryConfig);
}
