part of registry;

/// The process operating status describes the condition of the underlying process
/// which the [Registration] represents.
enum ProcessOpStatus {
  /// Despite being registered successfully, when called upon it failed to start.
  FailedToStart,
  /// The process has previous started and executed but has currently failed.
  Failure,
  /// The process as never been requested hence no attempt has been made to start it.
  NeverStarted,
  /// The process has been used before, currently offline, calling it should bring it back online.
  Offline,
  /// The process is currently available to receive request.
  Online,
}

typedef void ProcessAccessFunction(Map request);

/// Provides access to underlying process and various specification and data.
class Registration {
  String _name, _id;
  Version _ver;
  Uri _entryPoint;
  DateTime _created;
  RequestStatus _status;
  RegistrationStatus _regStatus;
  Isolate _currentIsolate;
  ReceivePort _currentReceivePort;
  SendPort _currentSendPort;
  bool _attempShutdownAfterUse,
      _autoRestartOnFail,
      _fatalError,
      _lazyLoad,
      _monitorErrorPort,
      _multiInstances,
      _idleShutDown,
      _requiresLogService;
  StreamController streamCtl = new StreamController();
  Stream _registryStream;


  bool get isFullyManaged=> _autoRestartOnFail && _monitorErrorPort ? true : false;
  bool get isMultiInstancesAllowed => _multiInstances;
  String get name =>_name;
  String get Id =>_id;
  RegistrationStatus get registrationStatus => _regStatus;
  Uri get pathToEntryPoint => _entryPoint;
  Version get version =>_ver;


  /// The registration needs configuration now.
  Registration(Map specification){
    loadSpecification(specification);
    _currentIsolate = specification[regSetValue.ProvisionedIsolate];
    _currentReceivePort = specification[regSetValue.RegistrarReceivePort];

    assert(_currentReceivePort != null);
    assert(_currentSendPort != null);
  }

  /// The registration is Lazy and can wait for a request before allocating resource.
  Registration.Lazy(Map specification){
    loadSpecification(specification);
    _lazyLoad = specification[regSetValue.LazyLoadable];
  }

  _updateRegistry(List inform)=> streamCtl.add(inform);

  /// Sets the standards attributions.
  loadSpecification(Map specification){
    _autoRestartOnFail = specification[regSetValue.AutoRestartOnFail];
    _created = new DateTime.now();
    _currentSendPort = specification[regSetValue.ProcessDefaultSendPort];
    _entryPoint = specification[regSetValue.EntryPointUri];
    _fatalError = specification[regSetValue.ErrorsAreFatal];
    _id = specification[regSetValue.ProcessId];
    _monitorErrorPort = specification[regSetValue.MonitorOnErrorPort];
    _multiInstances = specification[regSetValue.MultiInstanceAllowed];
    _name = specification[regSetValue.ProcessName];
    _requiresLogService = specification[regSetValue.ProvideLogService];
    _ver = new Version.parse(specification[regSetValue.ProcessVersion]);
  }

  /// Rejects the registration and closes down and resources.
  void _reject(){
    _currentIsolate?.kill();
    _currentReceivePort?.close();
    _regStatus = RegistrationStatus.Failed;
    streamCtl.close();
  }

  Stream _accept(){
    return _registryStream = streamCtl.stream;
}
}

/// Indicates the status of the process registration.
enum RegistrationStatus {
  /// The process is be setup and will be available soon.
  Configuring,
  /// Failed to be registered because the path to the entry
  /// point source was not reachable.
  FailedPath,
  /// Failed to be registered because the format of the
  /// version number was not semantically compatible;
  FailedVersion,
  /// Has been successfully registered and is available for use.
  Available,
  /// There has been a failure in execution, no attempt
  /// is being made to recover this process.
  Failed,
  /// Failed during operations and is being recovered,
  /// should be available soon;
  Recovery
}
