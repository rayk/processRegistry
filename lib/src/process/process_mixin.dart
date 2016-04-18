library process;

import 'dart:isolate';
import 'package:quiver/strings.dart';
import 'package:quiver/collection.dart';
import 'dart:developer';
import 'package:pub_semver/pub_semver.dart';
import 'dart:async';
import 'package:processRegistry/src/shared/configuration_keys.dart';
import 'package:uuid/uuid.dart';

export 'package:pub_semver/pub_semver.dart' show Version;

part 'process_config.dart';
part 'config_applicator.dart';
part 'isolate_operations.dart';


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

  _activateWithSpecification(List specification){

  }

  _establishChannel(){

  }

}




