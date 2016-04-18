part of process;

/// Returns a list of maps for the register and provision function.
Function portParts(Map configuration) {
  Map config = configuration;

  genEntry(configKey, Map target) {
    if (configKey == PTi.exchangePort) {
      if (config[PCv.portExchange]) {
        target[configKey] = new ReceivePort();
      } else {
        target[configKey] = null;
      }
    }

    if (configKey == PTi.loggingServiceExpected)
      (target[configKey] = config[PCv.linkToLogService]);

    if (configKey == PTi.broadCastStream) {
      if (config[PCv.createBroadCastStream]) {
        target[configKey] = null;
      } else {
        target[configKey] = null;
      }
    }
  }
  return genEntry;
}

Function registryParts(Map configuration) {
  Map config = configuration;
  Map args = config[PCv.spawnArgumentsMap];

  void genEntry(configKey, Map target) {
    if (configKey == PRe.communalSendPort)
      target[configKey] = config[PCv.communalReceivePort];
    if (configKey == PRe.id) (target[configKey] = config[PCv.uniqueIdentifier]);
    if (configKey == PRe.idleShutdown)
      (target[configKey] = config[PCv.collectibleIsolate]);
    if (configKey == PRe.isolate)
      (target[configKey] = Isolate.current.hashCode);
    if (configKey == PRe.lazyLoad) (target[configKey] = config[PCv.lazyLoad]);
    if (configKey == PRe.monitored)
      target[configKey] = config[PCv.setIsolateListeners];
    if (configKey == PRe.name) (target[configKey] = config[PCv.name]);
    if (configKey == PRe.pathList) target[configKey] = args[PSa.entryPoint];
    if (configKey == PRe.recover)
      (target[configKey] = config[PCv.restartOnFail]);
    if (configKey == PRe.startArgs) target[configKey] = args[PSa.startupArgs];
    if (configKey == PRe.unique) target[configKey] = config[PCv.multiInstances];
    if (configKey == PRe.version) target[configKey] = config[PCv.version];
  }

  return genEntry;
}

Function isolateParts(Map configuration) {
  Map config = configuration;

  void genEntry(configKey, Map target) {
    if (configKey == PTi.processRegistry) {
      if (config[PCv.requiresRegister]) {
        target[configKey] = "Place Holder";
      } else {
        target[configKey] = null;
      }
    }
  }
  return genEntry;
}

Function processParts(Map configuration) {
  Map config = configuration;

  void genEntry(configKey, Map target) {
    if (configKey == PTi.portRequestHandling) {
      if (!config[PCv.communalReceivePort]) {
        target[configKey] = "Place holder";
      } else {
        target[configKey] = null;
      }
    }
  }
  return genEntry;
}
