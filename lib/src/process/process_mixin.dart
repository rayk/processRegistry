library process;

import 'dart:isolate';
import 'package:pub_semver/pub_semver.dart';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'package:uuid/uuid.dart';

export 'package:pub_semver/pub_semver.dart' show Version;

part 'process_config.dart';


/// Used as base of every process and handle all the low level management
/// of the process.
abstract class ProcessMixin {
  Map  startupConfiguration;
  ReceivePort incomingRequest;
  SendPort outgoingResponses;
  SendPort logEntry;
  String processName;
  String versionNumber;
  DateTime processCreated;
  DateTime lastRequest;
  int requestCounter;
  int responseCounter;

  /// Make the configuration setting for the process. This Method is called
  /// automatically once the registry dependencies are in place.
  _applyConfiguration(Map processConfigurationSettings){

  }


  /// Starts the process so that it delivery it's outcome.
  startProcess(Map Startup);
}




