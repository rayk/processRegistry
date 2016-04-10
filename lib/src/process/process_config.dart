part of process;

/// Lookup for Configuration Actions.
Map<configKey, ConfigurationAction> configActionsLookup = {
  configKey.CollectibleIsolate: registrySetShutDowns,
  configKey.CreateBroadCastStream: setupBroadcastStream,
  configKey.DefaultProcessSendPort: portExchange,
  configKey.ExtractProcessArgs: processStartupConfig,
  configKey.FailOnUnCaughtExceptions: registryIsolateSetFail,
  configKey.LinkToLogService: registrySetLogService,
  configKey.MultiInstances: registrySetMultiInstance,
  configKey.MultipleReceivePorts: multiPortController,
  configKey.PortExchange: portExchange,
  configKey.ProcessListens: portExchange,
  configKey.RequestReplyToPortUsable: processSetReplyToUsable,
  configKey.RequiresRegister: setupOwnRegistry,
  configKey.RestartOnFail: registryRecoverFailure,
  configKey.SetIsolateListeners: registrySetErrorPortMonitoring,
  configKey.SetPerConsumerReceivePorts: multiPortController,
};

/// Creates a specification mapping describing how the process should be
/// configured in term of ports and low level behaviour. This is the first thing executed
/// when a service it attempted to be provisioned.
///
/// The default values are set for a anonymous process that accepts a start configuration
/// responses always on the same channel. Can be monitored and needs restarting when if falls over.
///
/// ### Configuration Options for Processes.
/// - supportAnonymousRequester, Process does not need to identify the requester.
/// - supportAutoShutDownOnFailure, Process stops and shutdown on errors and exceptions.
/// - supportBroadcasting, Process will  broadcast to all requester listening in.
/// - supportFailureRecovery, Registry will attempt to restart process if it crashes.
/// - supportLogging, Registry will a provide process with SendPort of Logger.
/// - supportMonitoring, Registry will attach Listeners and log issues.
/// - supportMultipleInstancePerRegistry, Process can be launched a number of time in the same registry.
/// - supportMultiRequesterChanel, Process can operate a number of SendPorts against it's one receive port.
/// - supportPerRequesterPrivateChannel, Process can handle many receive ports, each with their own SendPort.
/// - supportRequestStreaming, Process is continually listening for request.
/// - supportResourceSaving, Process can be shutdown by registry to save resources.
/// - supportResponseStreaming, Process returns a continuous stream of results.
/// - supportsReplyPortsInMessage, Process can use a reply to a request using a SendPort included in the request.
/// - supportStartupConfig, Process accepts a configuration when it's being launched.
/// - supportSubProcesses, Process requires it own Registry so it can have sub processes.
///
/// ### Configuration Examples.
/// - Single Use Process, returns only once takes not inputs.
///  - supportRequestStreaming = false,
///  - supportResponseStreaming = false,
///  - supportStartupConfig = false,
///
/// - Void Return Process, can receive continue request but does not return.
///   - supportRequestStreaming = true,
///   - supportResponseStreaming = false,
///
/// - Responses on a Stream and takes Stream of inputs.
///   - supportRequestStreaming = true,
///   - supportResponseStreaming = true,
///
configureProcess(ProcessMixin process, String processName, Version version,
    List args, String message,
    {bool supportsMonitoring: true, // Provide support for monitoring of errors.
    bool supportsBroadcasting:
        false, // Broadcast process with no assured delivery.
    bool supportsLogging: true, // Can send logging to a passed in sendPort.
    bool supportsAnonymousRequester:
        true, // No formal registration of the requester is required.
    bool supportsMultipleInstancePerRegistry:
        false, // Can run multi instances of process run in the same registry.
    bool supportsRequestStreaming:
        true, // Does the Process continually listens to a stream.
    bool supportsFailureRecovery: true, // Try to restart after exit.
    bool supportResponseStreaming:
        true, // Request to the process always results in a response.
    bool supportResourceSaving:
        false, // Can the process automatically be shutdown to save resources.
    bool supportsSubProcesses: false, // Can spawn it's own sub-processes.
    bool supportsStartupConfig:
        true, // Can the process access an Startup Configuration.
    bool supportsAutoShutdownOnFailures:
        true, // If there is a unhandled failure this process self terminates.
    bool supportsMultiRequesterChannel: true, // Many sendPorts will be created.
    bool supportPerRequesterPrivateChanel:
        false, // One ReceivePort per requester.
    bool supportsReplyPortsInMessages: true}) {
  /// There always needs to be a send port back to the requester.
  /// Passed in with the args when the Isolate is created.
  assert(args[0] is Map);

  var uuid = new Uuid();

  Map<configKey, bool> _processConfiguration = new Map.from({
    configKey.CollectibleIsolate: supportResourceSaving,
    configKey.CreateBroadCastStream: supportsBroadcasting,
    configKey.ExtractProcessArgs: supportsStartupConfig,
    configKey.FailOnUnCaughtExceptions: supportsAutoShutdownOnFailures,
    configKey.LinkToLogService: supportsLogging,
    configKey.MultiInstances: supportsMultipleInstancePerRegistry,
    configKey.MultipleReceivePorts: supportPerRequesterPrivateChanel,
    configKey.PortExchange: supportResponseStreaming,
    configKey.ProcessListens: supportsRequestStreaming,
    configKey.RequestReplyToPortUsable: supportsReplyPortsInMessages,
    configKey.RequiresRegister: supportsSubProcesses,
    configKey.RestartOnFail: supportsFailureRecovery,
    configKey.SetIsolateListeners: supportsMonitoring,
    configKey.SetPerConsumerReceivePorts: supportsMultiRequesterChannel,
  });

  Map _tempProvValues = new Map.from(args[0]);

  Map _processDetails = new Map.from({
    configKey.InitialArgs: new List.unmodifiable([args, message]),
    configKey.Instance: process,
    configKey.Name: processName,
    configKey.UniqueIdentifier: uuid.v4().toString().substring(0, 7),
    configKey.Version: version.toString(),
    configKey.TempExchangeSendPort:
        _tempProvValues[regProvisionValues.SendPort],
    configKey.DebuggerMode: _tempProvValues[regProvisionValues.Debug],
  });

  implementConfiguration(_processDetails, _processConfiguration);
}

/// Builds a configuration map for the registry and for the process.
/// Returns the registry via the SendPort provided in the Args and Listens
/// to for response from the registry.
///
/// It then passes that response along with the configuration map for the
/// process into startup process.
void implementConfiguration(
    Map configDetails, Map<configKey, bool> configSwitch) {
  Map regValues = new Map(); // Values for the registry.
  Map cesValues = new Map(); // Values for the process.

  configSwitch.forEach((K, V) {
    if (V == true) {
      ConfigValueApplicator applyConfig =
          configActionsLookup[K](configDetails, configSwitch);
      applyConfig(cesValues, regValues);
    }
  });

  /// Provide details as to how to setup this process in the registry.
  if (regValues.isNotEmpty) {
    cesValues[processSetValue.ExchangeOnPort].send(regValues);
    cesValues[processSetValue.MainReceivePort]
        .listen((Map processDependencies) {
      configDetails[configKey.Instance]._applyConfiguration();
    });
  }
}

ConfigValueApplicator multiPortController(Map configDetails, Map configSwitches) {}

/// Provide the Registry with a the sendPort side of the port the process
/// will be listening to.
ConfigValueApplicator portExchange(Map configDetails, Map configSwitches) {
  SendPort _tempExchangePort = configDetails[configKey.TempExchangeSendPort];
  ReceivePort _processMainReceivePort = new ReceivePort();
  SendPort _sendToExchangeWithRegistry = _processMainReceivePort.sendPort;

  void config(Map process, Map registry) {
    registry[regSetValue.ProcessDefaultSendPort] = _sendToExchangeWithRegistry;
    process[processSetValue.MainReceivePort] = _processMainReceivePort;
    process[processSetValue.ExchangeOnPort] = _tempExchangePort;
  }

  return config;
}

/// If there is a send port in request message send your response to it.
ConfigValueApplicator processSetReplyToUsable(Map configDetails, Map configSwitches) {
  bool _includedSendPortUse = configSwitches[configKey.RestartOnFail];

  void config(Map process, Map registry) {
    process[processSetValue.ReplyOnEnclosedSendPort] = _includedSendPortUse;
  }
  return config;
}

/// Extract out the startup args and message for the process if they exist.
/// Otherwise init the startup list to be a empty list.
ConfigValueApplicator processStartupConfig(Map configDetails, Map configSwitches) {
  List _passedInArgs = configDetails[configKey.InitialArgs];
  List _startupArgsList = [];
  String _startupMsg;
  var target = configDetails[configKey.Instance];

  /// If there is arg list and message
  if (_passedInArgs.length == 2) {
    _startupMsg = _passedInArgs[1];
  }

  /// If the Args list has something in position 1 that is a startup list.
  if (_passedInArgs[0].length == 2) {
    _startupArgsList = _passedInArgs[1] ?? new List.unmodifiable([]);
  }

  void config(Map process, Map registry) {
    target.startupConfiguration = {
      processStartup.ArgsList: _startupArgsList,
      processStartup.Message: _startupMsg
    };
  }
  return config;
}

ConfigValueApplicator registryIsolateSetFail(Map configDetails, Map configSwitches) {
  bool _fails = configSwitches[configKey.FailOnUnCaughtExceptions];

  void config(Map process, Map registry) {
    registry[regSetValue.ErrorsAreFatal] = _fails;
  }

  return config;
}

ConfigValueApplicator registryRecoverFailure(Map configDetails, Map configSwitches) {
  bool _recover = configSwitches[configKey.RestartOnFail];

  void config(Map process, Map registry) {
    registry[regSetValue.AutoRestartOnFail] = _recover;
  }

  return config;
}

/// Registry need to listen to and process the OnError port of the isolate.
ConfigValueApplicator registrySetErrorPortMonitoring(Map configDetails, Map configSwitches) {
  bool _value = configSwitches[configKey.SetIsolateListeners];

  void config(Map process, Map registry) {
    registry[regSetValue.MonitorOnErrorPort] = _value;
  }

  return config;
}

/// Registry needs to provide a logging service.
ConfigValueApplicator registrySetLogService(Map configDetails, Map configSwitches) {
  bool _logServiceNeeded = configSwitches[configKey.LinkToLogService];

  void config(Map process, Map registry) {
    registry[regSetValue.ProvideLogService] = _logServiceNeeded;
  }

  return config;
}

/// Informs the register that multiple instances of this process is ok.
ConfigValueApplicator registrySetMultiInstance(Map configDetails, Map configSwitches) {
  bool _multiInstance = configSwitches[configKey.MultiInstances];

  config(Map process, Map registry) {
    registry[regSetValue.MultiInstanceAllowed] = _multiInstance;
  }

  return config;
}

/// Let registry know that process can be shutdown for resource saving
/// When there is not port exchange, attempt immediate shutdown.
ConfigValueApplicator registrySetShutDowns(Map configDetails, Map configSwitches) {
  bool _afterUse = configSwitches[configKey.PortExchange] ? false : true;

  config(Map process, Map registry) {
    registry[regSetValue.ShutDownIdleIsolate] = true;
    registry[regSetValue.AttemptShutDownAfterUse] = _afterUse;
  }

  return config;
}

ConfigValueApplicator setupBroadcastStream(Map configDetails, Map configSwitches) {}

ConfigValueApplicator setupOwnRegistry(Map configDetails, Map configSwitches) {}

/// Configuration Action Type.
typedef void ConfigValueApplicator(
    Map processConfiguration, Map registryConfiguration);
typedef ConfigValueApplicator ConfigurationAction(
    Map configDetails, Map configSwitches);
