import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'control_factory.dart';
import 'fui_app_errors_handler.dart';
import 'fui_server.dart';
import 'fui_server_protocol.dart';
import 'models/app_state.dart';
import 'reducers.dart';

class fuiAppServices extends InheritedWidget {
  final fuiAppServices? parentAppServices;
  final bool? hideLoadingPage;
  final String? controlId;
  final int? reconnectIntervalMs;
  final int? reconnectTimeoutMs;
  final String pageUrl;
  final String assetsDir;
  final fuiAppErrorsHandler? errorsHandler;
  late final fuiServer server;
  late final Store<AppState> store;
  final Map<String, GlobalKey> globalKeys = {};
  final Map<String, ControlInvokeMethodCallback> controlInvokeMethods = {};
  final List<CreateControlFactory> createControlFactories;

  fuiAppServices(
      {super.key,
      required super.child,
      required this.pageUrl,
      required this.assetsDir,
      this.errorsHandler,
      this.parentAppServices,
      this.hideLoadingPage,
      this.controlId,
      this.reconnectIntervalMs,
      this.reconnectTimeoutMs,
      required this.createControlFactories}) {
    store = Store<AppState>(appReducer, initialState: AppState.initial());
    server = fuiServer(store, controlInvokeMethods,
        reconnectIntervalMs: reconnectIntervalMs,
        reconnectTimeoutMs: reconnectTimeoutMs,
        errorsHandler: errorsHandler);
    if (errorsHandler != null) {
      if (controlId == null) {
        // root error handler
        errorsHandler!.addListener(() {
          if (store.state.isRegistered) {
            server.triggerControlEvent("page", "error", errorsHandler!.error!);
          }
        });
      } else if (controlId != null && parentAppServices != null) {
        // parent error handler
        errorsHandler?.addListener(() {
          parentAppServices?.server
              .triggerControlEvent(controlId!, "error", errorsHandler!.error!);
        });
      }
    }
    // connect to a page
    var pageUri = Uri.parse(pageUrl);
    store.dispatch(PageLoadAction(pageUri, assetsDir, server));
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  void close() {
    server.disconnect();
  }

  static fuiAppServices? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<fuiAppServices>();

  static fuiAppServices of(BuildContext context) => maybeOf(context)!;
}
