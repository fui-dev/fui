import 'package:flutter/material.dart';

class fuiAppContext extends InheritedWidget {
  final ThemeMode? themeMode;

  const fuiAppContext(
      {super.key, required this.themeMode, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static fuiAppContext? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<fuiAppContext>();
}
