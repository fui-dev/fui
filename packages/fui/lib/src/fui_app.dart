import 'package:flutter/material.dart';

import 'control_factory.dart';
import 'fui_app_errors_handler.dart';
import 'fui_app_main.dart';
import 'fui_app_services.dart';

class fuiApp extends StatefulWidget {
  final String pageUrl;
  final String assetsDir;
  final bool? hideLoadingPage;
  final String? controlId;
  final String? title;
  final fuiAppErrorsHandler? errorsHandler;
  final int? reconnectIntervalMs;
  final int? reconnectTimeoutMs;
  final List<CreateControlFactory>? createControlFactories;

  const fuiApp(
      {super.key,
      required this.pageUrl,
      required this.assetsDir,
      this.hideLoadingPage,
      this.controlId,
      this.title,
      this.errorsHandler,
      this.reconnectIntervalMs,
      this.reconnectTimeoutMs,
      this.createControlFactories});

  @override
  State<fuiApp> createState() => _fuiAppState();
}

class _fuiAppState extends State<fuiApp> {
  String? _pageUrl;
  fuiAppServices? _appServices;

  @override
  void deactivate() {
    _appServices?.close();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageUrl != _pageUrl) {
      _pageUrl = widget.pageUrl;
      _appServices = fuiAppServices(
          parentAppServices: fuiAppServices.maybeOf(context),
          hideLoadingPage: widget.hideLoadingPage,
          controlId: widget.controlId,
          reconnectIntervalMs: widget.reconnectIntervalMs,
          reconnectTimeoutMs: widget.reconnectTimeoutMs,
          pageUrl: widget.pageUrl,
          assetsDir: widget.assetsDir,
          errorsHandler: widget.errorsHandler,
          createControlFactories: widget.createControlFactories ?? [],
          child: fuiAppMain(title: widget.title ?? "fui"));
    }
    return _appServices!;
  }
}
