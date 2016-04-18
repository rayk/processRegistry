import 'package:test/test.dart';
import 'dart:async';
import 'package:processRegistry/src/registry/registry.dart';

main(){

  group("Registrar",(){
    List toBeRegistered = [
      [
        "Accumulate",
        "0.0.1",
        ["example", "process_examples", "accumulate", "entry_point.dart"],
        ["Branch of", "startup", "options"]
      ],
      [
        "Echo",
        '0.0.2',
        ['example', "process_examples", "echo", "entry_point.dart"],
        ["Branch of", "startup", "options"]
      ],
      [
        "Echo2",
        "BadVersionNumberShouldFail",
        ['example', "process_examples", "echo", "entry_point.dart"],
        ["Branch of", "startup", "options"]
      ],
      [
        "Logger"
        '0.0.1',
        ['example', "process_examples", "echo", "entry_point.dart"],
        ["log", 'to', 'where']
      ],
      [
        "Spray",
        "0.0.1",
        ["example", "process_examples", "spray", "entry_point.dart"],
        ["Branch of", "startup", "options"]
      ],
      [
        "Fail",
        "0.0.0",
        ["does", "not", "exist", "should", "go", "failed", "entry_point.dart"],
        ["Branch of", "startup", "options"]
      ]
    ];

    List processlist = new List();

    onRegoCallBack(Registration rego){
      processlist.add(rego);
    }


    test("Should send back audit entry for process",(){

      StreamController testSCT = new StreamController();
      registrar(toBeRegistered, onRegoCallBack, true, testSCT.sink);

      testSCT.stream.listen((List entry){
        print("Requested: $entry");
      });


    });




  });




}