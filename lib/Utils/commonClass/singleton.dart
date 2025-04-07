import 'package:flutter/cupertino.dart';

class Singleton {
  static Singleton? instance;
  BuildContext? context;

  static Singleton? instanceInit() {
    instance ??= Singleton();
    return instance;
  }
}
