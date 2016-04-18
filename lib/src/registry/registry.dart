library registry;

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:async/async.dart';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'package:processRegistry/src/shared/status_keys.dart';

part 'file_path.dart';
part 'registration.dart';
part 'registrar.dart';

/// Holds all the Process [Registration] objects which where requested as part of
/// the creation of this registry.
class Registry {
  static Registry _instance;
  List<Map> _requestedRegistrations = new List();
  List<Registration> _processes = new List();
  List _processOpEvents = new List(); //Date, Process, Version, State, Debug, Assigned
  StreamGroup processUpdates = new StreamGroup();
  Stream _processOpUpdates;

  /// This is the constructor to used to instantiate a Registry.
  /// It is  scoped to the current isolate and the single instance is
  /// available within the current Isolate. Upon creating the Registry you
  /// can pass in the optional list of processes that you would like to register.
  ///
  /// Flipping the debugger flag just enable the Observatory Profiler.
  factory Registry({List<List<String>> processes, bool debugger: false}) {
    return _instance == null
        ? new Registry._internal(processes, debugger)
        : _instance;
  }

  Registry._internal(List processList, bool debug) {
    StreamController registryStreamCtl = new StreamController();
    _processOpUpdates = registryStreamCtl.stream;
    _processOpUpdates.listen((List opUpdate) => _processOpEvents.add(opUpdate));
    if (processList != null) {
      registrar(processList, _completeRegistration, debug, registryStreamCtl.sink);
    }
    _instance = this;
  }

  _completeRegistration(Registration registration) {
    if (!_processes.contains(registration.Id)) {
      processUpdates.add(registration._accept());
    } else {
      registration._reject();
    }
  }

  /// Return complete Audit Log of process events.
  Future<List> processAuditLog() async{
    return new List.unmodifiable(await _processOpEvents);
  }

  /// Returns a list of all the [Registration] Objects all with their state.
  List<Registration> get registrations {
    return new List.unmodifiable(_processes);
  }

  /// Returns a list of Maps which corresponds with the requested registration
  /// when the registry was first instantiated.
  List<Map> get requestedRegistration {
    return new List.unmodifiable(_requestedRegistrations);
  }

  @override
  toString() {
    StringBuffer sb = new StringBuffer("****** Registry Breakdown\r");
    sb.writeln(
        '- Registry Hashcode: ${this.hashCode} running on Isolate ${Isolate.current.hashCode}');
    for (Map r in _requestedRegistrations) {
      sb.writeln(
          "\tProcess: ${r[PRq.name]}( ${r[PRq.version]}) \t\t\tLocated: ${r[PRq.pathToEntry]}");
    }
    return sb.toString();
  }
}

/// Keys for  a Process Request
enum PRq { // Keys for a process request used in the Arg List passed to a process it started.
  debug, // Boolean indicator should process started in debug mode.
  name, // Name of the requested process
  pathToEntry, // List of the path names to the entry file.
  requestLazy, // If process is lazy treat this request as lazy.
  specNotRequired, // Service does not need to provide a specification.
  startUpConfig, // List of the process startup configs.
  state, // The status of the startup request.
  version, // The requested version.
  }

/// State of the request to register a process which was passed in when the
/// registry was first instantiated.
enum RequestStatus {
  /// The entry point has yet to be checked for validity.
  pending,

  /// A [Registration] object has been created for this process request.
  registered,

  /// The request to registry the requested process, see the
  /// corresponding [Registration] for further details.
  failed
}
