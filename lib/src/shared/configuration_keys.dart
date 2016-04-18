library sharedConfigurationKeys;



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

/// Registry Registration Values
enum RRv {
  AttemptShutDownAfterUse,
  AutoRestartOnFail,
  EntryPointUri,
  ErrorsAreFatal,
  LazyLoadable,
  MonitorOnErrorPort,
  MultiInstanceAllowed,
  ProcessDefaultSendPort,
  ProcessId,
  ProcessName,
  ProcessRegistry,
  ProcessVersion,
  ProvideLogService,
  ProvisionedIsolate,
  ProvisionStatus,
  RegistrarReceivePort,
  ShutDownIdleIsolate,
}

enum processSetValue{
  MainReceivePort, // Default or root ReceivePort associated with process.
  DistributedSendPort, // Send created during configuration intended for the registry.
  ExchangeOnPort, // Send port register wants to do initial exchange on.
  ReplyOnEnclosedSendPort, // Process should use the send point in the message.
}

enum specRequest{
  Debug, // Debug value Propagation
  SendPort, // Send provide by register for port exchange.
  EntryPoint, // Uri of the Entry of the process.
}