library registry;

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';

part 'file_path.dart';
part 'registration.dart';
part 'provision.dart';

Counter proCCount =
    new Counter("Process Registrations", "Total Number of  register processes");

attemptRegistration(Map entry, Function updateRegister) async {
  var aprTag = new UserTag('Attemping Process Registration');
  bool entryFileLocated;
  Registration registration;
  Map request = entry;

  Uri entryPointFile = toUri(request[ReqKey.pathToEntry]);
  inspect(entryPointFile);

  entryFileLocated = await isFileAccessible(entryPointFile);

  if (entryFileLocated) {
    registration = new Registration(request[ReqKey.name],
        request[ReqKey.version], entryPointFile, RegistrationStatus.Registered);
  } else {
    registration = new Registration(request[ReqKey.name],
        request[ReqKey.version], entryPointFile, RegistrationStatus.FailedPath);
  }

  scheduleMicrotask(() => updateRegister(registration));
  log("UpdateRegister MicroTask Scheduled.");
}

/// Holds all the Process [Registration] objects which where requested as part of
/// the creation of this registry.
class Registry {
  static Registry _instance;
  List<Map> _requestedRegistrations = new List();
  List<Registration> _processes = new List();

  /// This is the constructor to used to instantiate a Registry.
  /// It is  scoped to the current isolate and the single instance is
  /// available within the current Isolate. Upon creating the Registry you
  /// can pass in the optional list of processes that you would like to register.
  ///
  /// Flipping the debugger flag just enable the Observatory Profiler.
  factory Registry({List<List<String>> register, bool debugger: false}) {
    if (_instance == null) {
      assert(register.isNotEmpty);
      _instance = new Registry._internal(register);
    }
    return _instance;
  }

  Registry._internal(List processList) {
    Metrics.register(proCCount);
    for (List process in processList) {
      Map registrationEntry = {
        ReqKey.name: process.removeAt(0),
        ReqKey.version: process.removeAt(0),
        ReqKey.pathToEntry: new List.from(process),
        ReqKey.state: RequestStatus.pending
      };
      _requestedRegistrations.add(registrationEntry);
      attemptRegistration(
          registrationEntry, _updateEntry(_requestedRegistrations, _processes));
    }
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

  _updateEntry(List<Map> requested, List<Registration> executed) {
    List<Map> req = requested;
    List<Registration> exe = executed;

    executeRequest(Registration registration) {
      log("UpdateRegister MicroTask Executed");
      Map request =
          req.singleWhere((r) => (r[ReqKey.name] == registration.name));
      assert(request[ReqKey.state] == RequestStatus.pending);
      if (registration._registrationState != RegistrationStatus.Registered) {
        request[ReqKey.state] = RequestStatus.failed;
        request[ReqKey.rego] = registration._processEntryPoint;
      } else {
        request[ReqKey.state] = RequestStatus.registered;
      }
      exe.add(registration);
      proCCount.value++;
    }

    return executeRequest;
  }
}

enum ReqKey { name, version, pathToEntry, state, rego }

/// State of the request to register a process which was passed in when the registry was first instantiated.
enum RequestStatus {
  /// The entry point has yet to be checked for validity.
  pending,
  /// A [Registration] object has been created for this process request.
  registered,
  /// The request to registry the requested process, see the corresponding [Registration] for further details.
  failed
}
