import 'package:flutter/material.dart';

import '../fui_app.dart';
import '../fui_app_errors_handler.dart';
import '../fui_app_services.dart';
import '../models/control.dart';
import 'create_control.dart';

class fuiAppControl extends StatefulWidget {
  final Control? parent;
  final Control control;

  const fuiAppControl(
      {super.key, required this.parent, required this.control});

  @override
  State<fuiAppControl> createState() => _fuiAppControlState();
}

class _fuiAppControlState extends State<fuiAppControl> {
  final _errorsHandler = fuiAppErrorsHandler();

  @override
  Widget build(BuildContext context) {
    debugPrint("fuiApp build: ${widget.control.id}");

    var url = widget.control.attrString("url", "")!;
    var reconnectIntervalMs = widget.control.attrInt("reconnectIntervalMs");
    var reconnectTimeoutMs = widget.control.attrInt("reconnectTimeoutMs");

    return constrainedControl(
        context,
        fuiApp(
          controlId: widget.control.id,
          reconnectIntervalMs: reconnectIntervalMs,
          reconnectTimeoutMs: reconnectTimeoutMs,
          pageUrl: url,
          assetsDir: "",
          errorsHandler: _errorsHandler,
          createControlFactories:
              fuiAppServices.of(context).createControlFactories,
        ),
        widget.parent,
        widget.control);
  }
}
