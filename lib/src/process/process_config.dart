part of process;

/// Given a Process Configuration Value as a Key and return function to output
/// the required parts of the specification.
Map<PCv, Function> specificationParts = {
  PCv.collectibleIsolate: registryParts,
  PCv.communalReceivePort: portParts,
  PCv.createBroadCastStream: portParts,
  PCv.extractProcessArgs: processParts,
  PCv.failOnUnCaughtExceptions: isolateParts,
  PCv.instance: isolateParts,
  PCv.lazyLoad: registryParts,
  PCv.linkToLogService: registryParts,
  PCv.multiInstances: registryParts,
  PCv.name: processParts,
  PCv.portExchange: portParts,
  PCv.processListens: isolateParts,
  PCv.requestReplyToPortUsable: processParts,
  PCv.requiresRegister: registryParts,
  PCv.restartOnFail: isolateParts,
  PCv.setIsolateListeners: isolateParts,
  PCv.spawnArgumentsMap: processParts,
  PCv.uniqueIdentifier: processParts,
  PCv.version: processParts,
};

/// Builds the specification by taking the developer process configurations and
/// details and mapping them into  executable functions which is then provided
/// provision function.
List<Map> buildSpecification(Map configuration) {
  Map requestedSpec = new Map.unmodifiable(configuration);
  List result = new List();

  /// Picks all the closures related to the Process Configuration Values given.
  List<Function> specParts = new List();
  for (var key in requestedSpec.keys) {
    specParts.add(specificationParts[key](requestedSpec));
  }
  assert(requestedSpec.keys.length == specParts.length);

  /// Makes a Registry Entry Map based on the PRe enum
  Map registryEntry = new Map();
  List _exeList1 = new List();
  for (Function part in specParts) {
    if (!_exeList1.contains(part)) {
      PRe.values.forEach((e) => part(e, registryEntry));
      _exeList1.add(part);
    }
  }
  assert(registryEntry.keys.length == PRe.values.length);
  result.add(registryEntry);

  Map provisionTask = new Map();
  List _exeList2 = new List();
  for (Function part in specParts) {
    if (!_exeList2.contains(part)) {
      PTi.values.forEach((e) => part(e, provisionTask));
      _exeList2.add(part);
    }
  }
  assert(provisionTask.keys.length == PTi.values.length);
  result.add(provisionTask);

  return result;
}

/// Creates a specification mapping describing how the process should be
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
configureProcess(ProcessMixin process, String processName, String version,
    List args, String message,
    {bool supportAnonymousRequester: true, // Requester does not have register.
    bool supportAutoShutdownOnFailure: false, // Uncaught Exceptions Fatal.
    bool supportBroadcasting: false, // Response on a Broadcast Stream.
    bool supportFailureRecovery: true, // Restart if process dies.
    bool supportLazyLoad: false, // First actual request causes load.
    bool supportLogging: true, // Requires a logging send port.
    bool supportMonitoring: true, // Attach a listeners
    bool supportMultipleInstancePerRegistry: true, // Many Instance
    bool supportCommunalRequesterChannel: true, // Process has 1 receive port.
    bool supportRequestStreaming: true, // Request via stream or one off future.
    bool supportResourceSaving: true, // Collect Isolate to free resources.
    bool supportResponseStreaming: true, // Responses via stream else future.
    bool supportReplyPortsInMessage: true, // Embedded SendPorts Usable.
    bool supportStartupConfig: true, // Run config before processing messages.
    bool supportSubProcess: false}) {
  /// Process Configuration Values.
  Map _processConfiguration = new Map.from({
    PCv.collectibleIsolate: supportResourceSaving,
    PCv.communalReceivePort: supportCommunalRequesterChannel,
    PCv.createBroadCastStream: supportBroadcasting,
    PCv.extractProcessArgs: supportStartupConfig,
    PCv.failOnUnCaughtExceptions: supportAutoShutdownOnFailure,
    PCv.lazyLoad: supportLazyLoad,
    PCv.linkToLogService: supportLogging,
    PCv.multiInstances: supportMultipleInstancePerRegistry,
    PCv.portExchange: supportResponseStreaming,
    PCv.processListens: supportRequestStreaming,
    PCv.requestReplyToPortUsable: supportReplyPortsInMessage,
    PCv.requiresRegister: supportSubProcess,
    PCv.restartOnFail: supportFailureRecovery,
    PCv.setIsolateListeners: supportMonitoring,
    PCv.spawnArgumentsMap: extractSpawnArguments(args, message),
    PCv.instance: process,
    PCv.name: processName,
    PCv.uniqueIdentifier: new Uuid().v4().toString().substring(0, 7),
    PCv.version: version.toString(),
  });

  /// All Keys specified assertion.
  assert(_processConfiguration.length == PCv.values.length);
  List main = buildSpecification(_processConfiguration);

  process._activateWithSpecification(main);
}

/// Map the Arguments passed during the spawn of this process.
Map extractSpawnArguments(List args, String message) {
  assert(args[0] is SendPort);
  Map spawningArguments = {
    PSa.debug: args[1] is bool ? args[1] : false,
    PSa.entryPoint: args[2] is List ? args[2] : throw new ArgumentError(''),
    PSa.message: message,
    PSa.sendPort: args[0],
    PSa.startupArgs: args[3],
    PSa.lazyRequest: args[4],
    PSa.specNotRequired: args[5],
  };
  return spawningArguments;
}

/// Used the process configuration in the ProcessMixin
/// Developers configuration of the process.
enum PCv {
  // Process Configuration Values - Boolean switches for major Isolation and Port behaviour.
  collectibleIsolate, //
  communalReceivePort, //
  createBroadCastStream, // Process has a broadcast stream
  extractProcessArgs, //
  failOnUnCaughtExceptions, // Config Isolate to fail on exceptions
  instance, // Actual instance of the Process.
  lazyLoad, // Wait until there are actual request for the process before allocating.
  linkToLogService, // Pass on SendPort to the logging service.
  multiInstances, // Can have multiple instance of this process.
  name, // Process Name
  portExchange, // Get a sendPort from the process.
  processListens, //
  requestReplyToPortUsable, // If the request has a send port use for the response.
  requiresRegister, // Process requires registry for it's own processes.
  restartOnFail, // Automatic restart the process on failure.
  setIsolateListeners, // Set the registry OnError to listen for problems.
  spawnArgumentsMap,
  uniqueIdentifier, // Uniquely identifies the process.
  version, // Process version.
}

/// Process Registry Entry.
enum PRe {
  communalSendPort, // All register go down the one send port.
  id, // Absolute Identification number of the process.
  idleShutdown, // can this process be shutdown recover resources if it not used.
  isolate, // The isolate id that the process is running on.
  lazyLoad, // Can we wait until a it is need before loading the process.
  monitored, // Does the registry listen process management ports.
  name, // Name of the process.
  pathList, // List of the path the entry point.
  recover, // Does the Registry attempt to recover the process if it fails.
  startArgs, // The Args used in the startup of the process
  unique, // Can there only be one of this type of process in the registry.
  version, // The Version reported in code.
}

/// Process Spawning Argument.
enum PSa {
  // Process Spawning Arguments passed during the spawn.
  debug, // Boolean indicating should be debug mode.
  entryPoint, // List of the entry point path used to execute this process.
  lazyRequest, // Don't start the service just for this request.
  message, // String containing and registry messages.
  sendPort, // The requester is listening to the other end of this.
  startupArgs, // Args for the actual process to used at startup or configuration.
  specNotRequired, // When true we process to turn up assuming they already have a spec.
}

/// Provision Task Items.
enum PTi {
  exchangePort, // Establish two communication ports
  loggingServiceExpected, // Don't complete provisioning until a logging port is received.
  broadCastStream, // Create a broadcast stream.
  processRegistry, // Create a Registry in this Isolate.
  portRequestHandling, // Be prepared to for each requester to have own send/receive port.
}
