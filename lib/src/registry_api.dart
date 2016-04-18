import 'registry/registry.dart' show Registry;

export 'registry/registry.dart' show Registry, RequestStatus, Registration, RegistrationStatus, ProcessOpStatus;
export 'package:pub_semver/pub_semver.dart' show Version;

/// Only thrown when a called upon behaviour is not implemented.
class NotImplementedException implements Exception {
  String message;
  NotImplementedException(this.message);
}