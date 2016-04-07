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
  Online, }

typedef void ProcessAccessFunction(Map request);

/// The registration is the reference to the underlying process.
class Registration {
  DateTime _registered;
  List _provisionEvents;
  Map _specification;
  ProcessOpStatus _processOperatingState;
  ReceivePort _primaryReceivePort;
  RegistrationStatus _registrationState;
  String _name;
  Uri _processEntryPoint;
  Version _internal_version;


  /// Using this constructor will by pass the file existent check. This
  /// simply increases the odds of crashing when you attempt to kick off the
  /// entry_point for the process.
  ///
  /// All other integrity of the registration is maintained if you do used
  /// this constructor.
  Registration(this._name, String _version, this._processEntryPoint,
      this._registrationState) {
    _processOperatingState = ProcessOpStatus.NeverStarted;
    _registered = new DateTime.now();

    if (_registrationState != RegistrationStatus.FailedPath) {
      try {
        _internal_version = new Version.parse(_version);
        _primaryReceivePort = new ReceivePort();
      } catch (e) {
        _registrationState = RegistrationStatus.FailedVersion;
      }
    }
  }

  /// Called when you want to use the process associated with the
  /// particular registration.
  Future<Function>useProcess(String consumer, ReceivePort defaultPort)async{


  }

  /// Returns the common name for the process
  String get name => _name;
  /// Returns the operating status of the process represented by this registration.
  ProcessOpStatus get operatingStatus => _processOperatingState;
  /// The path where the source code is located for this process.
  Uri get pathToEntryPoint => _processEntryPoint;
  /// The Date and Time the Registration was created.
  DateTime get registrationDateTime => _registered;
  /// The Status the actual registration, provides information as failed registration reasons.
  RegistrationStatus get registrationStatus => _registrationState;
  /// Returns the semantic version number of the process.
  Version get version => _internal_version;

  @override
  toString() {
    StringBuffer sb = new StringBuffer("Registration Object");
    sb.writeln('Name: ${name}');
    sb.writeln('Version: ${_internal_version.toString()}');
    sb.writeln('Entry Point: ${_processEntryPoint.toString()}');
    sb.writeln('Reg State $_registrationState');
    sb.writeln('Operational State $_processOperatingState');
  }
}

/// Indicates the status of the registration.
enum RegistrationStatus {
  /// Failed to be registered because the path to the entry point source was not reachable.
  FailedPath,
  /// Failed to be registered because the format of the version number was not semantically compliant.
  FailedVersion,
  /// Has been successfully registered and can used.
  Registered, }
