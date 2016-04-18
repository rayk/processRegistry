part of registry;

/// Function that handles the registration of process and it's
/// entry into the registry.
///
///
registrar(List requestedProcesses, Function onComplete, bool debugger,
    Sink registryStream) async {
  for (List request in requestedProcesses) {
    Map processRequest = {
      PRq.name: request.removeAt(0),
      PRq.version: request.removeAt(0),
      PRq.pathToEntry: new List.from(request.removeAt(0)),
      PRq.startUpConfig: new List.from(request.removeAt(0)),
      PRq.state: RequestStatus.pending,
      PRq.debug: debugger,
    };

    registryStream.add([new DateTime.now(), processRequest]);

    await querySpecification(processRequest).then((Map specification) {
      if (specification[RRv.LazyLoadable]) {
        onComplete(new Registration.Lazy(specification));
      } else {
        onComplete(new Registration(specification));
      }
    });
  }
}

Future<Map> querySpecification(Map processRequest) async {
  Map processSpecification = new Map();
  ReceivePort specificationPort = new ReceivePort();
  Uri entryPoint = toUri(processRequest[PRq.pathToEntry]);
  Isolate spawnee;

  if (await isFileAccessible(entryPoint)) {
    try {
      spawnee = await Isolate.spawnUri(
          entryPoint,
          [
            specificationPort.sendPort,
            processRequest[PRq.debug],
            processRequest[PRq.pathToEntry],
            processRequest[PRq.startUpConfig],
            processRequest[PRq.requestLazy],
            processRequest[PRq.specNotRequired]
          ],
          "message");
    } on IsolateSpawnException catch (e) {
      throw new IsolateSpawnException("$e with a detailed crash message");
    }

    specificationPort.listen((Map specification) {

    });

    return processSpecification;
  } else {
    throw new ArgumentError(
        "An entry point can not be located at $entryPoint.");
  }
}
