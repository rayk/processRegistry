import 'package:test/test.dart';

import 'package:processRegistry/registry_lib.dart';


main(){
  group("Provision one way no reply process:",(){

    /// Registry does port exchange handing back only the SendPort with the
    /// Service listen on the other end.
    test("Should receive a SendPort to pass messages to.",(){

    });

    /// Registry just needs to me informed.
    test("Should terminate the process when I am completed with it.",(){

    });







  });

  group("Provision two way reply process:",(){

  });

  group("Provision a process that is able to provision it's own procces:",(){

  });
}