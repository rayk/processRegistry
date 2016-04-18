library querySpecificationTest;

import 'dart:async';

import 'package:processRegistry/src/registry/registry.dart';

import 'package:test/test.dart';

main() {
  group('Specification Query:', () {
    test("Should return a specification.", () async {
      Map testProcessRequest = {
        PRq.name: "Test process",
        PRq.version: '0.3.2',
        PRq.pathToEntry: [
          'example',
          'process_examples',
          'echo',
          'entry_point.dart'
        ],
        PRq.startUpConfig: ['just', 'some', 'startup', 'stuff'],
        PRq.state: RequestStatus.pending,
        PRq.debug: true,
        PRq.specNotRequired: false,
        PRq.requestLazy: true,

      };

      await querySpecification(testProcessRequest).then((var val){
        print(val);
      });


    });
  });
}
