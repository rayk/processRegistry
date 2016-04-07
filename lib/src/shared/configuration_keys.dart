library sharedConfigurationKeys;

/// Used the process configuration in the ProcessMixin
enum proConfigKeys {
  CreateBroadCastStream, // Process has a broadcast stream
  DefaultProcessSendPort, //
  ExclusiveIsolate, //
  ExtractProcessArgs, //
  FailOnUnCaughtExceptions,  // Config Isolate to fail on exceptions
  Id, // Unique Identifier.
  LinkToLogService, // Pass on SendPort to the logging service.
  MultiInstances, // Can have multiple instance of this process.
  Name, // Process Name
  PortExchange, // Get a sendPort from the process.
  RecoverFailedProcess, // Automatic restart the process on failure.
  ReplyOnRequestSendPort, //
  RequiresRegister, // Process requires registry for it's own processes.
  SetOnErrorPort, // Set
  SetPerConsumerReceivePorts, //
  UniqueIdentifier, //
  Version // Process version.
}
