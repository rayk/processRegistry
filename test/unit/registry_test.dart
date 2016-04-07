library registry_test;

import 'package:test/test.dart';
import 'package:processRegistry/src/registry/registry.dart';

main() {
  group('Grab Registry:', () {
    List toBeRegistered = [
      [
        "Accumulate",
        "0.0.1",
        "example",
        "process_examples",
        "accumulate",
        "entry_point.dart"
      ],
      [
        "Echo",
        '0.0.2',
        'example',
        "process_examples",
        "echo",
        "entry_point.dart"
      ],
      [
        "Echo2",
        "BadVersionNumberShouldFail",
        'example',
        "process_examples",
        "echo",
        "entry_point.dart"
      ],
      [
        "Spray",
        "0.0.1",
        "example",
        "process_examples",
        "spray",
        "entry_point.dart"
      ],
      [
        "Fail",
        "0.0.0",
        "does",
        "not",
        "exist",
        "should",
        "go",
        "failed",
        "entry_point.dart"
      ]
    ];

    test('Should always return same instance of registry.', () async {
      Registry testRegistry = new Registry(processes: toBeRegistered);
      expect(testRegistry, isNotNull);
      Registry testRegistry2 = new Registry();
      expect(testRegistry == testRegistry2, isTrue);
      Registry testRegistry3 = new Registry();
      expect(testRegistry3 == testRegistry && testRegistry == testRegistry2,
          isTrue);
      expect(testRegistry3 == testRegistry2, isTrue);
    });

    test('Should return a list of processes requesting to be registered.', () {
      var registry = new Registry();
      List pros = registry.requestedRegistration;
      expect(pros.length, equals(toBeRegistered.length));
    });

    test("Should show that two processes failed to register.", () {
      var registry = new Registry();
      List<Map> regPro = registry.requestedRegistration;
      var fails = regPro.where((e) => (e.containsValue(RequestStatus.failed)));
      expect(fails.length, equals(2));
    });

    test("Should return a list of registration objects.", () {
      var registry = new Registry();
      List<Registration> registrations = registry.registrations;
      expect(registrations.length, equals(5));
    });

    test("Should access public attributes in retrieved Registration Object.",
        () {
      var registry = new Registry();
      var results = registry.registrations.where((r) => r.name == "Echo");
      expect(results.length, equals(1));
      expect(results.first.name, equals("Echo"));
      expect(results.first.version.toString(), equals("0.0.2"));
      expect(results.first.pathToEntryPoint, equals(new isInstanceOf<Uri>()));
      expect(results.first.registrationStatus,
          equals(RegistrationStatus.Registered));
      expect(results.first.operatingStatus,
          equals(ProcessOpStatus.NeverStarted));
      expect(results.first.registrationDateTime, equals(new isInstanceOf<DateTime>()));
    });
  });
}
