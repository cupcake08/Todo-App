import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';

extension Log on Object {
  void log() => dev.log(toString());
}

extension Constraints on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
}
