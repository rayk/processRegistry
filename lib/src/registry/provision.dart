part of registry;

/// Establishes the Process on a Isolate as per the specification and then
/// makes an entry in the registration as to the outcome of the provisioning.
///
/// Assumptions : The registration has:
/// - Have never been provisioned before. -> Get The Spec
/// - Has Already been provisioned. -> Is it Still Online
/// - Another instance need to be provisioned. -> Confirm Another is Possible
///
/// - Called with the registration which be registered state.
/// - Spins up an Isolate and receives, the provisioning specification.
/// - Pause The Isolate, attach what ever it required.
/// - Create a monitor with recovery instructions.
/// - Enable the Isolate and check it for life
/// - Update the registration and that completed.
provisionProcess(Registration registration) async{

  assert(registration.registrationStatus == RegistrationStatus.Registered);




}

_retriveSpecification(){}

_spwanIsolate(Uri entryPoint, ArgsPayload, message)async{

}