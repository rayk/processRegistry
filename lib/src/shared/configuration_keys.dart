library sharedConfigurationKeys;

/// Used the process configuration in the ProcessMixin
enum configKey {
  CollectibleIsolate, //
  CreateBroadCastStream, // Process has a broadcast stream
  DebuggerMode, // Propagation of debug true/false from register.
  DefaultProcessSendPort, //
  ExtractProcessArgs, //
  FailOnUnCaughtExceptions,  // Config Isolate to fail on exceptions
  InitialArgs,
  Instance, // Actual instance of the Process.
  LinkToLogService, // Pass on SendPort to the logging service.
  MultiInstances, // Can have multiple instance of this process.
  MultipleReceivePorts, // Need to handle multiple receive ports.
  Name, // Process Name
  PortExchange, // Get a sendPort from the process.
  ProcessListens, //
  RequestReplyToPortUsable, // If the request has a send port use for the response.
  RequiresRegister, // Process requires registry for it's own processes.
  RestartOnFail, // Automatic restart the process on failure.
  SetIsolateListeners, // Set the registry OnError to listen for problems.
  SetPerConsumerReceivePorts, //
  TempExchangeSendPort, // The Temp Send Port provided by the registry.
  UniqueIdentifier, // Uniquely identifies the process.
  Version, // Process version.
}

/// Used to indicate the startup of the process.
enum processStartup{
  ArgsList, // List of arguments private for the process
  Message, // Message private for the process.
}

/// Used to let the registry known how a process should be managed.
enum processManagement{
  AggressivelyCollect, // Can the process be shut down when it is not used.
  AttemptEarlyCollection, // Attempt to collect after first use.
}

enum regSetValue {
  ShutDownIdleIsolate,
  AttemptShutDownAfterUse,
  MonitorOnErrorPort,
  ProcessRegistry,
  ErrorsAreFatal,
  AutoRestartOnFail,
  ProvideLogService,
  MultiInstanceAllowed,
  ProcessDefaultSendPort,
}

enum processSetValue{
  MainReceivePort, // Default or root ReceivePort associated with process.
  DistributedSendPort, // Send created during configuration intended for the registry.
  ExchangeOnPort, // Send port register wants to do initial exchange on.
  ReplyOnEnclosedSendPort, // Process should use the send point in the message.
}

enum regProvisionValues{
  Debug, // Debug value Propagation
  SendPort, // Send provide by register for port exchange.
}